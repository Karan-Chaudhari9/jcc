// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jcc/bloc/auth/auth_bloc.dart';
import 'package:jcc/bloc/login/login_bloc.dart';
import 'package:jcc/theme/colors.dart';

import '../../../bloc/user/register/user_register_bloc.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = "";
  String verificationId = "";
  final TextEditingController _otpController = TextEditingController();

  late LogInBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LogInBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.read<UserRegisterBloc>().add(GetUser(state.phoneNo));
            }else if (state is UnAuthenticated) {
              context.go('/login');
            }
          },
        ),
        BlocListener<UserRegisterBloc, UserRegisterState>(
          listener: (context, state) {
            if (state is UserRegistered) {
              context.go('/home');
            } else if (state is UserNotRegistered) {
              context.go('/user_register');
            } else if (state is GettingUser) {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20,),
                      Text("Please wait"),
                    ],
                  ),
                );
              },);
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SvgPicture.asset(
              "assets/backgrounds/opt_background.svg",
              width: MediaQuery.of(context).size.width,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Expanded(child: SizedBox()),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(30.0),
                      right: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 20.0),
                        child: Text(
                          "We have sent an OTP to your mobile number",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _otpController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "Enter OTP",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.darkMidnightBlue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.darkMidnightBlue,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: AppColors.darkMidnightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      BlocConsumer<LogInBloc, LogInState>(
                        bloc: _loginBloc,
                        listener: (context, state) {
                          if (state.isOtpVerified) {
                            // context.go('/home');
                            context.read<AuthBloc>().add(LoggedIn());
                            // Future.delayed(
                            //   const Duration(seconds: 0),
                            //   () {
                            //     final phoneNo = (context.read<AuthBloc>().state
                            //             as Authenticated)
                            //         .phoneNo;
                            //     context
                            //         .read<UserRegisterBloc>()
                            //         .add(GetUser(phoneNo));
                            //   },
                            // );
                          } else if (state.isOtpError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Something went wrong ${state.error.toString()}",
                                ),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                              dev.log("OTP: $otp", name: "OTP");
                              dev.log(
                                "VerificationId: ${state.verificationId}",
                                name: "OTP",
                              );
                              try {
                                final AuthCredential credential =
                                    PhoneAuthProvider.credential(
                                  verificationId:
                                      state.verificationId.toString(),
                                  smsCode: _otpController.text,
                                );
                                dev.log("Hello", name: "OTP");
                                await firebaseAuth
                                    .signInWithCredential(credential);
                                // context.go("/home");
                                context.read<AuthBloc>().add(LoggedIn());
                              } catch (e) {
                                rethrow;
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.darkMidnightBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
