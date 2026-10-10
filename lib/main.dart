import 'package:flutter/material.dart';

void main() => runApp(const NexoraApp());

const Color bg = Color(0xFF09090F);
const Color panel = Color(0xFF14141F);
const Color purple = Color(0xFF9B6DFF);
const Color purpleBright = Color(0xFFB79AFF);
const Color muted = Color(0xFF9291A5);

class NexoraApp extends StatelessWidget {
  const NexoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXORA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: purple,
          surface: panel,
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF171722),
          hintStyle: const TextStyle(color: Color(0xFF77768B), fontSize: 14),
          prefixIconColor: muted,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF292837)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: purple, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFF667A)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFF667A)),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  late final AnimationController _animation;
  late final Animation<double> _fade;
  bool _isSignUp = false;
  bool _obscure = true;
  bool _remember = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _fade = CurvedAnimation(parent: _animation, curve: Curves.easeOutCubic);
    _animation.forward();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _animation.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF272437),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _busy = false);
    _showMessage(_isSignUp
        ? 'تم إنشاء حساب تجريبي بنجاح — لا توجد بيانات محفوظة.'
        : 'تم تسجيل الدخول التجريبي — لم يتم التحقق من الحساب.');
  }

  Future<void> _googleDemo() async {
    _showMessage('واجهة Google تجريبية فقط. لم يتم الاتصال بحساب Google.');
  }

  void _forgotPassword() {
    final email = _email.text.trim();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Forgot password?'),
        content: Text(
          email.isEmpty
              ? 'أدخل بريدك الإلكتروني في شاشة الدخول أولًا. هذه نسخة تجريبية ولا ترسل رسائل.'
              : 'سنستخدم $email في تجربة استعادة كلمة المرور. لا يتم إرسال أي رسالة في هذه النسخة.',
          style: const TextStyle(color: muted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت', style: TextStyle(color: purpleBright)),
          ),
        ],
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _formKey.currentState?.reset();
    });
    _animation
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(top: -110, right: -100, child: GlowOrb(size: 270)),
          const Positioned(bottom: 70, left: -155, child: GlowOrb(size: 290)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width > 500 ? 70 : 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.035),
                        end: Offset.zero,
                      ).animate(_fade),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const BrandHeader(),
                          const SizedBox(height: 34),
                          Text(
                            _isSignUp ? 'Create your account' : 'Welcome back',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            _isSignUp
                                ? 'Join NEXORA and make it yours.'
                                : 'Sign in to continue your journey.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: muted, fontSize: 14),
                          ),
                          const SizedBox(height: 29),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_isSignUp) ...[
                                  const FieldLabel('FULL NAME'),
                                  const SizedBox(height: 9),
                                  TextFormField(
                                    controller: _name,
                                    textCapitalization: TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      hintText: 'Your name',
                                      prefixIcon: Icon(Icons.person_outline_rounded),
                                    ),
                                    validator: (v) =>
                                        (v == null || v.trim().length < 2)
                                            ? 'Enter your name'
                                            : null,
                                  ),
                                  const SizedBox(height: 18),
                                ],
                                const FieldLabel('EMAIL ADDRESS'),
                                const SizedBox(height: 9),
                                TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: const InputDecoration(
                                    hintText: 'you@example.com',
                                    prefixIcon: Icon(Icons.mail_outline_rounded),
                                  ),
                                  validator: (v) {
                                    final value = v?.trim() ?? '';
                                    if (value.isEmpty || !value.contains('@') ||
                                        !value.substring(value.indexOf('@') + 1).contains('.')) {
                                      return 'Enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                const FieldLabel('PASSWORD'),
                                const SizedBox(height: 9),
                                TextFormField(
                                  controller: _password,
                                  obscureText: _obscure,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: _isSignUp
                                      ? const [AutofillHints.newPassword]
                                      : const [AutofillHints.password],
                                  onFieldSubmitted: (_) => _submit(),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                                    suffixIcon: IconButton(
                                      tooltip: _obscure ? 'Show password' : 'Hide password',
                                      onPressed: () => setState(() => _obscure = !_obscure),
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    final value = v ?? '';
                                    if (value.length < 6) return 'Use at least 6 characters';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                if (!_isSignUp)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _remember,
                                          activeColor: purple,
                                          side: const BorderSide(color: muted),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          onChanged: (v) => setState(() => _remember = v ?? false),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Remember me',
                                          style: TextStyle(color: muted, fontSize: 12)),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: _forgotPassword,
                                        style: TextButton.styleFrom(
                                          foregroundColor: purpleBright,
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                        ),
                                        child: const Text('Forgot password?',
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  )
                                else
                                  const Padding(
                                    padding: EdgeInsets.only(top: 3, bottom: 8),
                                    child: Text(
                                      'By creating an account, you agree to our Terms & Privacy Policy.',
                                      style: TextStyle(color: muted, fontSize: 11, height: 1.5),
                                    ),
                                  ),
                                const SizedBox(height: 17),
                                GradientButton(
                                  label: _isSignUp ? 'Create account' : 'Sign in',
                                  loading: _busy,
                                  onPressed: _submit,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          const OrDivider(),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: _googleDemo,
                            icon: const GoogleMark(),
                            label: const Text('Continue with Google'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF11111A),
                              minimumSize: const Size.fromHeight(54),
                              side: const BorderSide(color: Color(0xFF302E40)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                _isSignUp
                                    ? 'Already have an account? '
                                    : "Don't have an account? ",
                                style: const TextStyle(color: muted, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: _toggleMode,
                                child: Text(
                                  _isSignUp ? 'Sign in' : 'Create account',
                                  style: const TextStyle(
                                    color: purpleBright,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield_outlined, size: 14, color: muted),
                              SizedBox(width: 6),
                              Text(
                                'DEMO UI  •  YOUR DETAILS ARE NOT SENT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF666579),
                                  fontSize: 9,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFBCA2FF), Color(0xFF7541E8), Color(0xFF3A216F)],
            ),
            boxShadow: [
              BoxShadow(color: purple.withOpacity(0.30), blurRadius: 32, spreadRadius: 1),
            ],
          ),
          child: const Icon(Icons.all_inclusive_rounded, size: 43, color: Colors.white),
        ),
        const SizedBox(height: 15),
        const Text(
          'N E X O R A',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 3.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'YOUR SPACE. YOUR WORLD.',
          style: TextStyle(
            color: Color(0xFF77758C),
            fontSize: 9,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFFB9B6CC),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.35,
        ),
      );
}

class GradientButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFFB49AFF), Color(0xFF8D5BFA), Color(0xFF6E3DE0)],
        ),
        boxShadow: [
          BoxShadow(color: purple.withOpacity(0.22), blurRadius: 20, offset: const Offset(0, 7)),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: Divider(color: Color(0xFF292837), height: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'OR CONTINUE WITH',
              style: TextStyle(
                color: Color(0xFF77758C),
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Divider(color: Color(0xFF292837), height: 1)),
        ],
      );
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 20,
        height: 20,
        child: Center(
          child: Text(
            'G',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF8AB4F8),
            ),
          ),
        ),
      );
}

class GlowOrb extends StatelessWidget {
  final double size;
  const GlowOrb({super.key, required this.size});

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                purple.withOpacity(0.15),
                const Color(0xFF6537B8).withOpacity(0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),
      );
}
