import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_portal_ui/extensions/context_extension.dart';
import 'package:mobile_portal_ui/pages/class/class_page.dart';
import 'package:mobile_portal_ui/pages/enquete/enquete_page.dart';
import 'package:mobile_portal_ui/pages/home/home_page.dart';
import 'package:mobile_portal_ui/pages/mail/mail_page.dart';
import 'package:mobile_portal_ui/pages/main/tab_navigator.dart';
import 'package:mobile_portal_ui/pages/other/other_page.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = useState<List<Widget>>([
      const HomePage(),
      const ClassPage(),
      const MailPage(),
      const EnquetePage(),
      const OtherPage(),
    ]);

    final navigatorKeys = useState([
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ]);

    final selectedIndex = useState(0);

    return WillPopScope(
      onWillPop: () async {
        final keyTab = navigatorKeys.value[selectedIndex.value];
        if (keyTab.currentState != null && keyTab.currentState!.canPop()) {
          return !await keyTab.currentState!.maybePop();
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: List.generate(
            widgets.value.length,
            (index) => Offstage(
              offstage: index != selectedIndex.value,
              child: TabNavigator(
                navigatorKey: navigatorKeys.value[index],
                page: widgets.value[index],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ホーム',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: '授業',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: '連絡',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'アンケート',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'その他',
              tooltip: '',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex.value,
          showSelectedLabels: !context.isIphoneMiniSize,
          showUnselectedLabels: !context.isIphoneMiniSize,
          onTap: (index) {
            selectedIndex.value = index;
          },
          selectedFontSize: 12,
        ),
      ),
    );
  }
}
