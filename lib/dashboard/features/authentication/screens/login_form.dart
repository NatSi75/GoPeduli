import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:gopeduli/dashboard/features/authentication/controllers/login_controller.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    controller.email.clear();
    controller.password.clear();
    return Form(
        key: controller.loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: GoPeduliSize.paddingHeightSmall),
          child: Column(
            children: [
              TextFormField(
                cursorColor: GoPeduliColors.secondary,
                style: const TextStyle(
                    fontSize: GoPeduliSize.fontSizeBody,
                    color: GoPeduliColors.white),
                controller: controller.email,
                validator: GoPeduliValidator.validateEmail,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.secondary, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.secondary, width: 1),
                    ),
                    prefixIcon: Icon(
                      Symbols.email_rounded,
                      color: GoPeduliColors.white,
                    ),
                    labelStyle: TextStyle(
                        color: GoPeduliColors.white,
                        fontSize: GoPeduliSize.fontSizeBody),
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                    )),
              ),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightUltraSmall,
              ),
              Obx(
                () => TextFormField(
                  cursorColor: GoPeduliColors.secondary,
                  style: const TextStyle(
                      fontSize: GoPeduliSize.fontSizeBody,
                      color: GoPeduliColors.white),
                  controller: controller.password,
                  validator: (value) =>
                      GoPeduliValidator.validateEmptyText('Password', value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: GoPeduliColors.secondary, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: GoPeduliColors.secondary, width: 1),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value =
                              !controller.hidePassword.value,
                          icon: Icon(
                            controller.hidePassword.value
                                ? Symbols.visibility_off_rounded
                                : Symbols.visibility_rounded,
                            color: GoPeduliColors.white,
                          )),
                      prefixIcon: const Icon(
                        Symbols.password_rounded,
                        color: GoPeduliColors.white,
                      ),
                      labelStyle: const TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody),
                      label: const Text('Password',
                          style:
                              TextStyle(fontSize: GoPeduliSize.fontSizeBody))),
                ),
              ),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => Checkbox(
                        activeColor: GoPeduliColors.quaternary,
                        checkColor: GoPeduliColors.white,
                        side: const BorderSide(color: GoPeduliColors.white),
                        value: controller.rememberMe.value,
                        onChanged: (value) =>
                            controller.rememberMe.value = value!),
                  ),
                  const Text('Remember Me',
                      style: TextStyle(
                          fontSize: GoPeduliSize.fontSizeBody,
                          color: GoPeduliColors.white)),
                ],
              ),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.emailAndPasswordSignIn(),
                  //onPressed: () => controller.registerAdmin(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GoPeduliColors.quaternary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              GoPeduliSize.borderRadiusSmall))),
                  child: const Text('Login',
                      style: TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody)),
                ),
              ),
            ],
          ),
        ));
  }
}
