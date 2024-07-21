import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_app/auth/screens/login.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color.fromARGB(255, 55, 57, 175),
        //   leading: Builder(builder: (BuildContext context) {
        //     return IconButton(
        //         icon:
        //             const Icon(Icons.keyboard_arrow_left, color: Colors.white),
        //         onPressed: () {
        //           Navigator.pushReplacementNamed(context, Login.routeName);
        //         } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
        //   }),
        //   automaticallyImplyLeading: false,
        //   title: Text('Forgot Password',
        //       style: GoogleFonts.poppins(
        //           fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              // padding: EdgeInsets.only(left: 50, right: 50),
              padding: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SWAK WI-FI TERMS OF SERVICE AND PRIVACY POLICY",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 11 : 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'IMPORTANT! READ THE FOLLOWING TERMS OF SERVICE ("TERMS OF SERVICE") BEFORE USING THIS WIRELESS WI-FI SERVICE ("SERVICE") OFFERED BY SWAK (“PROVIDER”) WHICH YOU ARE PATRONIZING AND ACCESSING THE SERVICE.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'BY ACCESSING AND USING THE SERVICES, YOU AGREE TO BE BOUND BY ALL THE TERMS SET FORTH HEREIN. IF YOU DO NOT AGREE WITH THESE TERMS OF SERVICE, YOU MUST NOT ACCESS OR USE THE SERVICE.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Services',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'This ÏService is provided with conditioned upon your acceptance without modification of these Terms of Service. The Service is provided solely for you to make legitimate use of the internet and you acknowledge and agree to receive advertisements and promotions while doing so.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Registration and Passwords',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'To access the Services, you may be asked to complete an online registration form or authenticate. In consideration for your access to, and ability, to use the Services, you agree to provide true, current, complete and accurate information as requested. As part of the registration process, you may be asked to provide an email address, or to login in using your mobile number, username and password for authentication. You alone are responsible for keeping that password and username confidential, and for any and all activity that occurs on the Services under your email, password or username. You alone are responsible for the security of your password. We strongly recommend that you do not disclose your password to anyone. We will never ask you for your password in any unsolicited communication (such as letters, phone calls or email messages).',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Code of Conduct',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'As a condition of your continued access to and use of this Service, you agree to abide by all applicable national, provincial, territorial and other laws and regulations, the other conditions of these Terms of Service, and any other rules which may be published from time to time by us. In addition, without limiting the foregoing, you agree not to:',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      // padding: EdgeInsets.symmetric(
                      //   // vertical: useMobileLayout ? 30 : 60,
                      //   horizontal: 30,
                      // ),
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '•	upload, post, e-mail or otherwise transmit any material using the Services that:',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	is known by you to be false, inaccurate, or misleading;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	infringes any patent, trade-mark, trade secret, copyright or other proprietary or privacy rights of any party;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	constitutes unsolicited or unauthorized advertising, promotional materials, “junk mail,” “spam,” “chain letters,” “pyramid schemes,” or any other form of solicitation;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	is unlawful, harmful, threatening, abusive, harassing, tortious, defamatory, vulgar, obscene, libelous, invasive of another’s privacy, hateful, racially, ethnically, pornographic or otherwise objectionable;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	you were compensated or granted any consideration by any third party to upload, post, e-mail or transmit unless otherwise authorized by us in writing; or',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	contains any form of destructive software such as a virus, worm, Trojan horse, time bomb, cancelbot, or any other harmful components or any other computer file, program; ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	send any unsolicited commercial electronic messages;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	harvest or otherwise collect or store communications send through the Service or any information (including personally identifiable information) about other users of the Service;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	for the purpose of misleading others, create a false identity of the sender or the origin of a message, forge headers or otherwise manipulate identifiers in order to disguise the origin of any material transmitted through the Services;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	attempt to gain unauthorized access to the Services, other computer systems or networks connected to the Services, through password mining or any other means;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	interfere with, disrupt or create undue burden on the Services; ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	exceed any applicable bandwidth caps or limitations; or',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	use, download or otherwise copy, or provide to any person or entity any user directory or other user or usage information or any portion thereof.',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Contests',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'From time to time we may offer and/or co sponsor contests or other promotions through the Service. Each of these activities shall be governed by specific rules accessible when the contest or promotion is offered or when you submit your entry.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Links & Advertisements',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We may offer links to websites which are owned and operated by third parties, as well as advertisements for products and services that are offered by us or third parties. We provide these links and advertisements as a convenience to our visitors. We do not review the content of such third party content, and neither endorse, nor are responsible for, any content, advertising, products, services or other materials on or available from such third parties. ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You assume full responsibility for your use of third party websites. Such websites are governed by terms and conditions different from those applicable to this Service, and we encourage you to review the terms and privacy policies of those third parties before using their websites.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Disclaimer / Limitation of Liability',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'THE LAWS OF CERTAIN JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LEGAL WARRANTIES, LIABILITY OR CERTAIN DAMAGES OR LIMITATION OF REPRESENTATIONS MADE CONCERNING GOODS OR SERVICES. IF THESE LAWS APPLY TO YOU, SOME OR ALL OF THE BELOW EXCLUSIONS OR LIMITATIONS MAY NOT APPLY TO YOU.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'THESE SERVICES ARE BEING PROVIDED ON AN "AS IS" BASIS AND WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. SWAK DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. SWAK DOES NOT WARRANT THAT THE SERVICES WILL MEET YOUR REQUIREMENTS, BE UNINTERRUPTED, ERROR-FREE OR FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS. ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'IN NO EVENT SHALL SWAK BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES THAT RESULT FROM OR IN CONNECTION WITH THE USE OF, OR THE INABILITY TO USE, THE SERVICES, EVEN IF SWAK HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Indemnity',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You agree to indemnify and hold harmless SWAK, its affiliates, members, officers, employees, agents, and licensors from and against any and all losses, expenses, damages, claims, fines, penalties, costs and liabilities (including reasonable legal and accounting fees), resulting from (a) any material you (or anyone acting under your email, password or username) upload, post, e-mail or otherwise transmit through the Services, and/or (b) your (or anyone acting under your email, password or username) use of the Services, connection thereto, or any alleged violation by you of these Terms of Service, including the Code of Conduct set out above.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Privacy',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Please review our Privacy Policy below for details on the manner in which we collect, use, disclose and otherwise manage personal information.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Changes & Termination',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We reserve the right at any time and from time to time to modify or discontinue, temporarily or permanently, the Services (or any part thereof) with or without notice. We may block information, transmissions or access to certain information, services, products or domains or prioritize, restrict, or set limits (such as bandwidth allocations, or limits on types of content accessed or transferred) on your use of the Service for certain applications to protect the Service, the public or other users. Therefore, messages and other content may be deleted before delivery. ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Further, we reserve the right to change these Terms of Service at any time and to notify you by providing you with an updated version of the Terms of Service when you log-in. You are responsible for regularly reviewing the Terms of Service, including, without limitation, by checking the date of "Last Update" at the bottom of this document. Continued use of the Services after any such changes shall constitute your consent to be bound by such changes, with continued provision of the use of the Service constituting consideration from SWAK to you for so being bound. Your only right with respect to any dissatisfaction with (1) these Terms of Service, or (2) any policy or practice of ours in operating the Services, is to stop using the Services.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Trademarks',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'All posted marks are a trademark of SWAK. Other marks, graphics, typefaces, trade dress, trademarks and logos are property of SWAK or of their respective owners. Our trademarks, trade dress and other intellectual property may not be used in any manner for any purpose without our express written consent.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Applicable Laws',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Unless the applicable laws of your jurisdiction expressly require that the laws of such jurisdiction govern, these Terms of Service are governed by and construed in accordance with the laws of applicable therein, and any dispute is to be submitted to a court of competent jurisdiction.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'If any provision of the present Terms of Service shall be unlawful, void, or for any reason unenforceable, then such provision shall be severable from these Terms of Service and shall not affect the validity and enforceability of any remaining provisions. These Terms of Service and any and all other legal notices made available to you through the Services, including the Privacy Policy, constitute the entire agreement between you and SWAK with respect to the use of the Services.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Notice',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Notices to you may be made via email or regular mail or, in cases of changes to these Terms of Service by posting notices or links to such notice when you log-in to the Services. If you have any questions or comments regarding these Terms of Service please contact us at SWAK.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'PRIVACY POLICY',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We recognize that privacy is important. This Privacy Policy applies to your use of this wireless Wi-Fi Service (the “Services”) offered by SWAK. We have prepared this Privacy Policy to describe the manner in which we collect, use, disclose and otherwise manage personal information in connection with the Services. ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Information We Collect and How We Use It',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'The term "personal information" means information about an identifiable individual, including name, address, email address, phone number and other information relating to an individual.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We may collect personal information when you: ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      // padding: EdgeInsets.symmetric(
                      //   // vertical: useMobileLayout ? 30 : 60,
                      //   horizontal: 30,
                      // ),
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '•	Connect to the Internet using the Services;',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	Sign up to receive newsletters and other promotional communications; or',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                          Text(
                            '•	Contact us with a comment, question or complaint. ',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: useMobileLayout ? 10 : 13,
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Wi-Fi Service: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "In order to use the Services, you must be at least 13 years of age. You may be asked to register by connecting your social media profile from one of the following 3rd party websites: Facebook, Twitter, LinkedIn, or other social media networks. If you do so, we will collect your name, email address, city, gender and other information disclosed to you at the time you connect through the social media networks. Alternatively, you may also be asked to register by providing your name, email address, city, gender, country, year of birth, and phone number. Your registration information is used to provide you access to and otherwise administer the Service, including the provision of tailored advertisements and other offers from us or our marketing partners while you are connected to the Service. We may collect log information about how and when you use our Service, such as your MAC address, social activity, location of device, advertising performance, and coupon redemptions.",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text:
                          "Newsletters, Text Messages and Promotional Materials: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "When you register to use the Service, you may also sign up to receive our email newsletter, SMS text messages and other communications. When you subscribe to our newsletter, SMS text messages or other communications, we will use your email address or phone number to send you information about our product and service offerings or those of our marketing partners. You may remove yourself from our newsletter list by clicking the “unsubscribe” link that appears at the bottom of each of our e-mails. If you have signed up to receive SMS text messages, you may unsubscribe by following the opt-out instructions provided in your SMS messages.",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Surveys and Customer Research: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "From time to time, we may offer you the opportunity to participate in one of our surveys or other customer research. We use this information to help us understand our customers and to enhance our product and service offerings and promotions.",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Contact Us: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "When you send email or other communications to us, we may use and retain those communications in order to process your inquiries, respond to your requests and improve the Services.",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Disclosure of Personal Information',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We will not disclose, trade, rent, sell or otherwise transfer your personal information, without your consent, except as otherwise set out herein.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Service Provider Arrangements: We may transfer (or otherwise make available) your personal information to our affiliates and other third parties who assist us with providing the Services. For example, we may use service providers to host our website and send advertisements or other marketing communications on our behalf. Your personal information may be maintained and processed by our affiliates and other third-party service providers in the Philippines. We ensure that all affiliates and other third parties that are engaged to perform services on our behalf and are provided with personal information are contractually required to observe the intent of this Privacy Policy and our privacy practices. Our service providers are given only the information they need to perform their designated functions, and we do not authorize them to use or disclose personal information for their own purposes. For additional information about our third-party service providers, contact us as set out below.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Sale of Business: We may transfer any information we have about you as an asset in connection with a merger or sale (including transfers made as part of insolvency or bankruptcy proceedings) involving all or part of SWAK or as part of a corporate reorganization or stock sale or other change in corporate control.  Legal: We, our affiliates other service providers may provide your personal information in response to a search warrant or other legally valid inquiry or order, or to an investigative body in the case of a breach of an agreement or contravention of law, or as otherwise required by applicable Philippine law. We may also disclose personal information where necessary for the establishment, exercise or defense of legal claims, as part of the administration of our loss prevention program, or as otherwise permitted by law.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Technology Information',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'When you access the Services, our servers automatically log certain information that your browser sends whenever you visit a website. These server logs may include information such as your web request, Internet Protocol address, MAC address, location (such as GPS signals sent by a mobile device) or information that can be used to approximate your location (such as a cell ID), browser type, browser language, connection history, and the date and time of your request.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Cookies: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'We may use a technology called "cookies". A cookie is a tiny element of data that websites can send to your browser, which may then be stored on your device so we can recognize you when you return. We use cookies to improve the quality of our Service, including for storing user preferences, improving ad selection, and tracking user trends. You may set your Web browser to notify you when you receive a cookie or to not accept certain cookies. However, if you decide not to accept cookies from us, you may not be able to take advantage of all of the features of our Services.',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Advertising: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'We and other third parties (such as ad networks, data exchanges, and other service providers) may also use cookies and similar technologies to provide you with advertisements and promotions when you use our Services. The information collected by these third parties may be used to tailor ads you see both on our Services and on third-party websites. You can choose not to receive tailored advertising from listed ad networks, data exchanges, and other service providers using this online tool. You can opt out of Google’s specific use of cookies for these purposes by visiting Google’s Ads Preferences Manager. If you opt out of receiving tailored advertising from a third party, including Google, you may still see ads about us, but those ads will not be customized by the companies that you opt-out of.',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: "Third party links: ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              'When you use our services, you may be presented with links to websites that we do not own or operate. Except as provided herein, we will not provide any of your personal information to these third parties without your consent. We provide links to third party websites as a convenience to the user. These links are not intended as an endorsement of or referral to the linked websites. The linked websites have separate and independent privacy statements, notices and terms of use, which we recommend you read carefully. We do not have any control over such websites, and therefore we have no responsibility or liability for the manner in which the organizations that operate such linked websites may collect, use or disclose, secure and otherwise treat your personal information.',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: useMobileLayout ? 10 : 13),
                        )
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We may present links in a format that enables us to keep track of whether these links have been followed. We use this information to improve the quality of our content and services.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Information Security',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We have implemented reasonable administrative, technical and physical safeguards in an effort to protect against unauthorized access, use, modification and disclosure of personal information in our custody and control. Unfortunately, no collection or transmission of information over the Internet or other publicly accessible communications networks can be guaranteed to be 100% secure, and therefore, we cannot ensure or warrant the security of any such information.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Data Integrity',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We take reasonable steps to ensure that the personal information we process is accurate, complete, and current, but we depend on our users to update or correct their personal information whenever necessary.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Accessing and Updating Personal Information',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You have the right to access, update, and delete your personal information in our custody and control, subject to certain exceptions prescribed by law. You may request access, updating and deletion of your personal information by emailing or writing to us at the contact information set out below, or by vising our  My Profile Opt-Out and Data Deletion Tool. We may request certain personal information for the purposes of verifying the identity of the individual seeking access to their personal information records. We will not charge any costs for you to access your personal information in our records or to access our privacy practices.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Retention of Information',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We may keep a record of your personal information, correspondence or comments, in a file specific to you. We will utilize, disclose or retain your personal information for as long as necessary to fulfill the purposes for which that personal information was collected and as permitted or required by law.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Changes to this Privacy Policy',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'This Privacy Policy may be updated periodically to reflect changes to our personal information practices. The revised Privacy Policy will be presented when you sign-in to use the Services. We strongly encourage you to please refer to this Privacy Policy often for the latest information about our personal information practices.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Questions',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text:
                          "Any questions about this Privacy Policy should be addressed to ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: useMobileLayout ? 10 : 13,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'privacy@swakwifi.com',
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: useMobileLayout ? 10 : 13,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await UrlLauncher.launch(
                                    "https://privacy@swakwifi.com");
                              })
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
