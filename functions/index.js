const functions = require("firebase-functions");
const admin = require("firebase-admin");
const midtransClient = require("midtrans-client");
const cors = require("cors")({ origin: true }); // Penting jika kamu akses dari Flutter Web

admin.initializeApp();

// 👉 Fungsi untuk generate Snap Token
exports.createSnapToken = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    const snap = new midtransClient.Snap({
      isProduction: false,
      serverKey: "SB-Mid-server-IHTa1lC0l_cbqghWFGpHjdWB",
      clientKey: "SB-Mid-client-txbENWFeMzkGDZ7b",
    });

    try {
      const orderId = `ORDER-${Date.now()}`;

      const parameter = {
        transaction_details: {
          order_id: orderId,
          gross_amount: req.body.amount,
        },
        credit_card: {
          secure: true,
        },
        customer_details: req.body.customer,
      };

      // Simpan dulu order ke Firestore (untuk referensi webhook nanti)
      await admin.firestore().collection("orders").doc(orderId).set({
        user_id: req.body.user_id,
        items: req.body.items,
        total: req.body.amount,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      const transaction = await snap.createTransaction(parameter);
      res.json({ snapToken: transaction.token, orderId: orderId });
    } catch (err) {
      console.error(err);
      res.status(500).send(err.message);
    }
  });
});

// 👉 Fungsi untuk menerima webhook dari Midtrans
exports.handleTransactionWebhook = functions.https.onRequest(async (req, res) => {
  const event = req.body;

  try {
    if (!event.order_id || !event.transaction_status) {
      return res.status(400).send("Invalid payload");
    }

    const { order_id, transaction_status, gross_amount, fraud_status } = event;

    // Cari data order berdasarkan order_id
    const orderDoc = await admin.firestore().collection("orders").doc(order_id).get();

    if (!orderDoc.exists) {
      return res.status(404).send("Order not found");
    }

    const orderData = orderDoc.data();

    // Simpan transaksi ke Firestore
    await admin.firestore().collection("transactions").doc(order_id).set({
      user_id: orderData.user_id,
      order_id: order_id,
      items: orderData.items,
      total: parseFloat(gross_amount),
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      status: transaction_status,
      fraud_status: fraud_status || null,
    });

    return res.status(200).send("Transaction recorded successfully");
  } catch (error) {
    console.error("Webhook error:", error);
    return res.status(500).send("Internal Server Error");
  }
});
