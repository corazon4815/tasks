# Tasks

간단하고 깔끔한 **Flutter 기반 투두 앱**입니다.  

### 프로젝트 구조
```bash
lib/
 ├─ main.dart                 # 앱 엔트리포인트, 테마 관리 및 ThemeMode 토글
 ├─ core/
 │   └─ theme_action.dart     # InheritedWidget: 테마 전환 콜백 전달
 ├─ pages/
 │   ├─ home_page.dart        # 메인 할 일 목록, 바텀시트 열기, 스낵바 표시
 │   └─ todo_detail_page.dart # 상세 페이지
 ├─ widgets/
 │   ├─ add_todo_sheet.dart   # 할 일 추가 시트 (제목/세부/즐겨찾기)
 │   ├─ todo_view.dart        # 할 일 카드 UI (완료/즐겨찾기 토글)
 │   └─ no_todo.dart          # 비어 있을 때 안내 카드
 └─ models/
     └─ todo_entity.dart  
```

### 실행 방법

```bash
flutter pub get
flutter run
# Android
flutter build apk
# iOS
flutter build ios
```