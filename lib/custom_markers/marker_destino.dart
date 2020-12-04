part of 'markers.dart';

class MarkerDestinoPainter extends CustomPainter {

  final String descripcion;
  final double metros;

  MarkerDestinoPainter(this.descripcion, this.metros);  


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black;
    
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;
    
    // Dibujar Circulo Negro
    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR), 
      circuloNegroR, 
      paint
    );

    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(circuloNegroR, size.height - circuloNegroR), 
      circuloBlancoR, 
      paint
    );

    final Path path = new Path();
    path.moveTo( 10, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(10, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // Caja Blanca
    final cajaBlanca = Rect.fromLTWH(10, 20, size.width - 20, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Caja Negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(10, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    // Dibujar textos
    double kilometros = this.metros / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    TextSpan textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400 ),
      text: '$kilometros'
    );

     TextPainter textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 80,
      minWidth: 80
    );

    textPainter.paint(canvas, Offset(5, 35));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400 ),
      text: 'Kms'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center
    )..layout(
      maxWidth: 70
    );

    textPainter.paint(canvas, Offset(25, 67));

    // Mi Ubicacion
    textSpan = new TextSpan(
      style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400 ),
      text: '$descripcion'
    );

    textPainter = new TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: '...'
    )..layout(
      maxWidth: size.width - 100
    );

    textPainter.paint(canvas, Offset(90, 35));

  }

  @override
  bool shouldRepaint(MarkerDestinoPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(MarkerDestinoPainter oldDelegate) => false;
}