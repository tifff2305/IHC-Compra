import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class VisaCardWidget extends StatefulWidget {
  const VisaCardWidget({super.key});

  @override
  State<VisaCardWidget> createState() => _VisaCardWidgetState();
}

class _VisaCardWidgetState extends State<VisaCardWidget> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tarjeta de credito visual
        CreditCardWidget(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          showBackView: isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          cardBgColor: Colors.blue.shade800,
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand brand) {},
          labelCardHolder: 'Titular de la tarjeta',
          labelValidThru: 'Valido hasta',
          labelExpiredDate: '',
        ),
        
        // Formulario para ingresar datos
        CreditCardForm(
          formKey: formKey,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          onCreditCardModelChange: onCreditCardModelChange,
          obscureCvv: true,
          obscureNumber: true,
          isHolderNameVisible: true,
          isCardNumberVisible: true,
          isExpiryDateVisible: true,
          enableCvv: true,
          cvvValidationMessage: 'Por favor ingrese un CVV válido',
          dateValidationMessage: 'Por favor ingrese una fecha válida',
          numberValidationMessage: 'Por favor ingrese un número de tarjeta válido',
          cardNumberValidator: (String? cardNumber) {
            return null;
          },
          expiryDateValidator: (String? expiryDate) {
            return null;
          },
          cvvValidator: (String? cvv) {
            return null;
          },
          cardHolderValidator: (String? cardHolderName) {
            return null;
          },
          onFormComplete: () {
            // Llamado cuando el formulario esta completo
          },
          autovalidateMode: AutovalidateMode.disabled,
          disableCardNumberAutoFillHints: false,
          inputConfiguration: const InputConfiguration(
            cardNumberDecoration: InputDecoration(
              labelText: 'Número de Tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
              border: OutlineInputBorder(),
            ),
            expiryDateDecoration: InputDecoration(
              labelText: 'Fecha de Expiración',
              hintText: 'MM/AA',
              border: OutlineInputBorder(),
            ),
            cvvCodeDecoration: InputDecoration(
              labelText: 'CVV',
              hintText: 'XXX',
              border: OutlineInputBorder(),
            ),
            cardHolderDecoration: InputDecoration(
              labelText: 'Titular de la Tarjeta',
              hintText: 'Nombre completo',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}