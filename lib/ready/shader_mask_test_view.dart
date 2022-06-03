import 'package:awesome_flutter/widget/scaffold_view.dart';
import 'package:flutter/material.dart';

class ShaderMaskTestView extends StatefulWidget {
  const ShaderMaskTestView({Key? key}) : super(key: key);

  @override
  State<ShaderMaskTestView> createState() => _ShaderMaskTestViewState();
}

class _ShaderMaskTestViewState extends State<ShaderMaskTestView> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

  @override
  Widget build(BuildContext context) {
    return ScaffoldView(
      title: 'Shader Mask Test View',
      body: Container(
        color: Theme.of(context).highlightColor,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: .8,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _wrapAnimatedShaderMask(
                Image.asset('assets/images/iPhoneCase12.png', color: Colors.white),
                Colors.purpleAccent,
              ),
              Center(
                child: _wrapAnimatedShaderMask(
                  Text('', style: TextStyle(color: Colors.white, fontSize: 55)),
                  Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Text('GO'),
        onPressed: () => controller.isCompleted ? controller.reverse() : controller.forward(),
      ),
    );
  }

  Widget _wrapAnimatedShaderMask(Widget child, Color color) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) => ShaderMask(
        shaderCallback: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Colors.white.withOpacity(0)],
          stops: [controller.value, controller.value + 0.1],
        ).createShader,
        child: child,
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }
}
