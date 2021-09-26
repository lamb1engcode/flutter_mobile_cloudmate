import 'package:cloudmate/src/routes/app_pages.dart';
import 'package:cloudmate/src/themes/app_colors.dart';
import 'package:cloudmate/src/themes/font_family.dart';
import 'package:cloudmate/src/themes/theme_service.dart';
import 'package:cloudmate/src/ui/classes/widgets/character_counter.dart';
import 'package:cloudmate/src/ui/classes/widgets/dialog_add_answer.dart';
import 'package:cloudmate/src/ui/common/dialogs/dialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

class CreateQuestionScreen extends StatefulWidget {
  @override
  _CreateQuestionScreenState createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();
  List<String> _answers = ['A đúng', 'B đúng', 'C đúng', 'Tất cả đều đúng'];
  List<String> _corrects = [];
  String _question = '';
  String _duration = '';

  hideKeyboard() => textFieldFocus.unfocus();

  bool _checkIsCorrect(String answer) {
    return _corrects.contains(answer);
  }

  _handleAddAnswer(String answer) {
    setState(() {
      _answers.add(answer);
    });
  }

  _handleToggleAnswer(String answer) {
    int index = _corrects.indexOf(answer);
    setState(() {
      if (index != -1) {
        _corrects.removeAt(index);
      } else {
        _corrects.add(answer);
      }
    });
  }

  _handlePressedAddQuestion() async {
    await dialogAnimationWrapper(
      context: context,
      dismissible: true,
      slideFrom: 'bottom',
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: DialogAddAnswer(
        handleFinish: _handleAddAnswer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: ThemeService.systemBrightness,
        centerTitle: true,
        elevation: .0,
        leading: IconButton(
          onPressed: () => AppNavigator.pop(),
          icon: Icon(
            PhosphorIcons.caretLeft,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Tạo câu hỏi',
          style: TextStyle(
            fontSize: 15.sp,
            fontFamily: FontFamily.lato,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print(_duration);
              AppNavigator.pop();
            },
            icon: Icon(
              PhosphorIcons.checkBold,
              size: 20.sp,
              color: colorPrimary,
            ),
          ),
        ],
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Form(
          key: _formKey,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 2.5.sp),
                  Divider(
                    height: .25,
                    thickness: .25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 12.0),
                            _buildLineInfo(
                              context,
                              'Nhập câu hỏi',
                              'Hãy nhập tên bài kiểm tra',
                              _questionController,
                            ),
                            _buildDivider(context),
                            _buildLineInfo(
                              context,
                              'Đặt thời gian trả lời (giây)',
                              'Hãy đặt thời gian trả lời cho câu hỏi',
                              _durationController,
                            ),
                            _buildDivider(context),
                            SizedBox(height: 8.sp),
                            _buildTitle(context, 'Câu trả lời'),
                            SizedBox(height: 4.sp),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 22.sp),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 10,
                                children: _answers.map((answer) {
                                  return GestureDetector(
                                    onTap: () {
                                      _handleToggleAnswer(answer);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6.5.sp,
                                        horizontal: 20.sp,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          30.sp,
                                        ),
                                        color: _checkIsCorrect(answer)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                      child: Text(
                                        answer,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 24.sp),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineInfo(context, title, valid, controller) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.fromLTRB(14.0, 18.0, 12.0, 4.0),
      child: TextFormField(
        maxLines: null,
        controller: controller,
        cursorColor: Theme.of(context).textTheme.bodyText1!.color,
        cursorRadius: Radius.circular(30.0),
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontSize: _size.width / 26.0,
          fontWeight: FontWeight.w500,
        ),
        validator: (val) {
          return null;
        },
        onChanged: (val) {
          setState(() {
            if (title == 'Nhập câu hỏi') {
              _question = val.trim();
            } else {
              _duration = val.trim();
            }
          });
        },
        inputFormatters: [
          title != 'Nhập câu hỏi'
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter,
        ],
        obscureText: title == 'Mật khẩu' ? true : false,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.only(
            left: 12.0,
          ),
          border: InputBorder.none,
          labelText: title,
          labelStyle: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.8),
            fontSize: _size.width / 26.0,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: title == 'Nhập câu hỏi'
              ? CharacterCounter(min: 60, value: _question.length)
              : null,
        ),
      ),
    );
  }

  Widget _buildDivider(context) {
    return Divider(
      thickness: .25,
      height: .25,
      indent: 25.0,
      endIndent: 25.0,
    );
  }

  Widget _buildTitle(context, title) {
    return Padding(
      padding: EdgeInsets.only(left: 22.sp, right: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.lato,
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(.72),
            ),
          ),
          IconButton(
            onPressed: () => _handlePressedAddQuestion(),
            icon: Icon(
              PhosphorIcons.plusCircleBold,
              color: colorPrimary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
