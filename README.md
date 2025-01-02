# Riverpod과 GoRouter를 사용한 카운터 프로젝트 생성 과정

이 문서는 Flutter를 사용하여 카운터 앱을 만드는 과정을 단계별로 설명합니다.

## 1. Flutter 프로젝트 생성
Flutter 프로젝트를 생성하는 첫 단계입니다. 터미널(맥) 또는 명령 프롬프트(윈도우)를 열고 다음 명령어를 실행합니다.

```bash
# 프로젝트 생성 : counter 라는 이름의 새 프로젝트를 만듭니다
flutter create counter

# 프로젝트 폴더로 이동 : 방금 만든 프로젝트 폴더로 들어갑니다
cd counter
```

> 💡 **참고하기**: `flutter create` 명령어는 Flutter 앱 개발에 필요한 기본 파일들을 자동으로 생성해줍니다.

## 2. 필요한 패키지 추가
앱 개발에 필요한 외부 패키지들을 추가합니다. `pubspec.yaml` 파일을 열어 다음 내용을 추가합니다.

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 추가
  flutter_riverpod: ^2.4.9    # 상태 관리를 위한 패키지
  riverpod_annotation: ^2.3.3 # 코드 자동 생성을 위한 패키지
  go_router: ^14.6.2         # 화면 이동을 위한 패키지

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  # 추가
  riverpod_generator: ^2.3.9  # Riverpod 코드 생성기
  build_runner: ^2.4.7        # 코드 생성 도구
```

> 💡 **참고하기**: 
> - `dependencies`는 앱 실행에 필요한 패키지들입니다.
> - `dev_dependencies`는 개발 과정에서만 필요한 패키지들입니다.
> - 버전 앞의 `^` 기호는 호환되는 최신 버전을 자동으로 사용하겠다는 의미입니다.

## 3. 패키지 설치
추가한 패키지들을 실제로 다운로드하고 설치합니다.

```bash
flutter pub get
```

> 💡 **참고하기**: 이 명령어는 `pubspec.yaml`에 명시된 모든 패키지를 자동으로 다운로드합니다.

## 4. 프로젝트 구조 설정
프로젝트의 코드를 체계적으로 관리하기 위해 필요한 폴더들을 만듭니다.

```bash
# lib 폴더 안에 provider 폴더를 만듭니다
mkdir -p lib/provider
```

> 💡 **참고하기**: 
> - `lib` 폴더는 우리가 작성할 코드가 들어가는 메인 폴더입니다.
> - `provider` 폴더는 상태 관리 관련 코드들을 모아두는 곳입니다.

## 5. Riverpod 코드 생성 설정
Riverpod는 코드 자동 생성 기능을 제공합니다. 이를 활성화하기 위한 명령어를 실행합니다.

```bash
# 코드 생성 도구를 실행합니다
flutter pub run build_runner watch
```

> 💡 **참고하기**: 
> - `build_runner watch`는 코드 변경을 감지하여 자동으로 필요한 코드를 생성합니다.
> - 터미널 창을 하나 더 열어서 이 명령어를 실행한 상태로 두면 편합니다.

## 6. 상태 관리 구현 

### Riverpod Provider란?
- 숫자가 변경되면 화면을 자동으로 업데이트

이렇게 Provider를 사용하면 앱의 여러 부분에서 같은 데이터를 쉽게 공유하고 관리할 수 있습니다.

### ProviderScope 설정
Riverpod를 사용하기 위해서는 앱의 최상위 위젯을 ProviderScope로 감싸야 합니다. `lib/main.dart` 파일에서 다음과 같이 설정합니다:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // ProviderScope로 감싸서 앱 전체에서 Riverpod를 사용할 수 있게 합니다
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

> 💡 **참고하기**: 
> - `ProviderScope`는 Riverpod의 상태 관리 기능을 앱 전체에서 사용할 수 있게 해주는 위젯입니다.
> - 반드시 앱의 최상위에 위치해야 합니다.
> - 이 설정이 없으면 Provider를 사용할 수 없습니다.

### Provider 구현 예시
아래 예제에서 계산기의 상태(숫자, 결과값 등)를 관리하는 코드를 작성합니다. `lib/provider/provider.dart` 파일을 만들고 다음 코드를 입력합니다. 

[부록 A : @riverpod 사용방법](#부록-a--riverpod-어노테이션-상세-사용법)


```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 자동 생성될 코드와 연결하는 부분
part 'provider.g.dart';

// 계산기의 상태를 관리하는 클래스
@riverpod // 어노테이션을 이용하여 프로바이더 생성
class Counter extends _$Counter {
  // 초기 상태를 0으로 설정
  @override
  int build() => 0;

  // 숫자를 1 증가시키는 함수
  void increment() {
    state++;
  }

  // 숫자를 1 감소시키는 함수
  void decrement() {
    state--;
  }
}
```

> 💡 **참고하기**: 
> - `@riverpod`는 상태 관리 코드를 자동으로 생성해주는 특별한 표시입니다.
> - `state`는 현재 숫자값을 나타냅니다.
> - `build()`는 처음 시작할 때의 숫자를 설정합니다.
> - Provider를 사용하면 앱의 여러 화면에서 같은 숫자를 볼 수 있습니다.

## 7. 앱 실행 및 테스트
작성한 코드가 잘 동작하는지 확인합니다.

```bash
# 앱 실행
flutter run
```

> 💡 **참고하기**: 
> - 에뮬레이터나 실제 기기가 연결되어 있어야 합니다.
> - 첫 실행은 시간이 좀 걸릴 수 있습니다.

## 8. 개발 도구 설정
개발에 도움이 되는 도구들을 설정합니다.

1. VS Code에서 Flutter 확장 프로그램 설치
   - VS Code의 확장 프로그램 탭에서 'Flutter' 검색
   - 공식 Flutter 확장 프로그램 설치

2. Flutter DevTools 활성화
   - VS Code에서 `F5` 키를 눌러 디버그 모드로 실행
   - 자동으로 DevTools가 활성화됨

3. 추천 플러그인: Flutter Riverpod Snippets
   - 게시자: robert-brunhage
   - VS Marketplace 링크: [https://open-vsx.org/vscode/item?itemName=robert-brunhage.flutter-riverpod-snippets]
   - Riverpod 코드 작성을 더 쉽게 도와주는 코드 스니펫 제공

> 💡 **참고하기**: 
> - Flutter 확장 프로그램은 코드 자동 완성, 디버깅 등 편리한 기능을 제공합니다.
> - DevTools는 앱의 성능 분석, 위젯 검사 등을 할 수 있는 도구입니다.
> - Flutter Riverpod Snippets은 Riverpod 관련 코드를 빠르게 작성할 수 있게 도와줍니다.

## 9. Riverpod 위젯 사용하기

Riverpod를 사용하여 상태를 관리할 때는 특별한 위젯들을 사용해야 합니다. 주로 사용되는 위젯들은 다음과 같습니다:

### 9.1. ConsumerWidget
상태 변화를 감지하고 화면을 자동으로 업데이트하는 기본 위젯입니다.

```dart
class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Provider의 상태를 읽어옵니다
    final count = ref.watch(counterProvider);
    
    return Text('현재 카운트: $count');
  }
}
```

> 💡 **참고하기**: 
> - `ConsumerWidget`은 `StatelessWidget`과 비슷하지만 `ref` 매개변수가 추가됩니다.
> - `ref.watch()`는 상태 변화를 감지하여 자동으로 화면을 업데이트합니다.

### 9.2. ConsumerStatefulWidget
상태 관리가 필요한 복잡한 위젯을 만들 때 사용합니다.

```dart
// 1. ConsumerStatefulWidget 정의
class CounterScreen extends ConsumerStatefulWidget {
  const CounterScreen({super.key});

  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

// 2. ConsumerState 구현
class _CounterScreenState extends ConsumerState<CounterScreen> {
  // 지역 변수 선언 가능
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 초기화 코드
  }

  @override
  Widget build(BuildContext context, ref) {
    // ref를 통해 Provider 접근
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('현재 카운트: $count'),
        if (isLoading) 
          const CircularProgressIndicator(),
        ElevatedButton(
          onPressed: () {
            setState(() => isLoading = true);
            ref.read(counterProvider.notifier).increment();
            setState(() => isLoading = false);
          },
          child: const Text('증가'),
        ),
      ],
    );
  }
}
```

> 💡 **참고하기**: 
> - `ConsumerStatefulWidget`은 `StatefulWidget`의 Riverpod 버전입니다.
> - `ConsumerState`는 `State` 클래스의 Riverpod 버전으로, `ref` 객체가 내장되어 있습니다.
> - `setState`와 Riverpod의 상태 관리를 함께 사용할 수 있습니다.

### 9.3. ref 객체 사용법

```dart
// 1. watch: 상태 변화 감지 및 자동 업데이트
final count = ref.watch(counterProvider);

// 2. read: 상태 값만 일회성으로 읽기
final counterNotifier = ref.read(counterProvider.notifier);
counterNotifier.increment();

// 3. listen: 상태 변화 감지 및 특정 동작 실행
ref.listen(counterProvider, (previous, next) {
  if (next > 10) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('경고'),
        content: Text('숫자가 너무 큽니다!'),
      ),
    );
  }
});
```

> 💡 **참고하기**: 
> - `watch`는 상태 변화를 계속 감지하여 화면을 업데이트합니다.
> - `read`는 상태를 한 번만 읽을 때 사용합니다.
> - `listen`은 상태 변화를 감지하여 특정 동작을 실행할 때 사용합니다.



## 부록 A : @riverpod 어노테이션 상세 사용법
[ㄴ 6. 상태관리 구현](#6-상태-관리-구현)

### A.1. 클래스 기반 Provider
```dart
// 상태를 변경할 수 있는 Provider
@riverpod
class MyState extends _$MyState {
  @override
  int build() => 0;  // 초기값 설정
  
  void updateState(int newValue) {
    state = newValue;  // 상태 업데이트
  }
}

// 읽기 전용 Provider
@Riverpod(keepAlive: true)  // keepAlive로 상태 유지
class ReadOnlyState extends _$ReadOnlyState {
  @override
  String build() => 'Initial Value';
}
```

### A.2. 함수 기반 Provider
```dart
// 단순 값을 제공하는 Provider
@riverpod
String simpleValue(ref) => 'Hello';

// 다른 Provider를 참조하는 Provider
@riverpod
int combinedState(ref) {
  final counter = ref.watch(counterProvider);
  final other = ref.watch(otherProvider);
  return counter + other;
}

// Future를 반환하는 비동기 Provider
@riverpod
Future<List<String>> fetchItems(ref) async {
  final response = await http.get(Uri.parse('api/items'));
  return response.body;
}
```

### A.3. 상태 변화 감지하기

1. **watch를 사용한 자동 갱신**
```dart
@riverpod
class TotalCount extends _$TotalCount {
  @override
  int build() {
    // 다른 Provider들의 변화를 감지
    final count1 = ref.watch(counter1Provider);
    final count2 = ref.watch(counter2Provider);
    return count1 + count2;
  }
}
```

2. **listen을 사용한 사이드 이펙트 처리**
```dart
@riverpod
class NotificationHandler extends _$NotificationHandler {
  @override
  void build() {
    ref.listen(counterProvider, (previous, next) {
      if (next > 10) {
        showNotification('높은 숫자 경고!');
      }
    });
  }
}
```

### A.4. 자주 하는 실수와 해결 방법

1. **잘못된 예시**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ❌ 잘못된 방법: 직접 변수 수정
  int count = 0;
  void increment() {
    count++;  // state를 사용하지 않음
  }
}
```

2. **올바른 예시**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ✅ 올바른 방법: state 사용
  void increment() {
    state++;  // state를 통한 업데이트
  }
}
```

### A.5. 코드 생성 명령어

```bash
# 한 번만 실행
flutter pub run build_runner build

# 지속적으로 감시하며 실행 (개발 시 권장)
flutter pub run build_runner watch

# 캐시 삭제 후 실행 (문제 발생 시)
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

> 💡 **참고하기**: 
> - Provider 파일을 수정할 때마다 build_runner를 실행해야 합니다.
> - `watch` 모드를 사용하면 파일 저장 시 자동으로 코드가 생성됩니다.
> - 코드 생성에 문제가 있다면 `clean` 후 다시 시도해보세요.

## 부록 B : Riverpod 어노테이션 작성 가이드

### B.1. 기본 설정하기

1. **필요한 패키지 추가**
```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

dev_dependencies:
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.7
```

2. **파일 상단에 필요한 코드 추가**
```dart
// provider.dart 파일
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 자동 생성될 코드 연결
part 'provider.g.dart';
```

### B.2. @riverpod 어노테이션 사용하기
[build 함수가 필요한 이유](#c1-build-함수가-필요한-이유)
1. **기본 형태**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;  // 반드시 build 메서드 구현
}
```

2. **keepAlive 옵션 사용**
```dart
// 상태를 계속 유지하고 싶을 때
@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  Map<String, dynamic> build() => {};
}
```

### B.3. 상태 업데이트 메서드 추가하기

1. **단순 상태 업데이트**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // 상태 변경 메서드
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}
```

2. **비동기 상태 업데이트**
```dart
@riverpod
class UserData extends _$UserData {
  @override
  Future<String> build() async => 'No data';

  // 비동기 업데이트 메서드
  Future<void> fetchData() async {
    state = const AsyncValue.loading();  // 로딩 상태
    try {
      final data = await apiCall();  // API 호출
      state = AsyncValue.data(data);  // 성공
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);  // 에러
    }
  }
}
```

### B.4. 함수형 Provider 작성하기

1. **단순 값 반환**
```dart
@riverpod
String greeting(ref) => 'Hello, World!';
```

2. **매개변수 사용**
```dart
@riverpod
String greetPerson(ref, {required String personName}) => 'Hello, $personName!';

// 사용할 때
final greeting = ref.watch(greetPersonProvider(personName: 'John'));
```

3. **다른 Provider 참조**
```dart
@riverpod
int doubleCount(ref) {
  final count = ref.watch(counterProvider);
  final other = ref.watch(otherProvider);
  return count * other;
}
```

### B.5. 상태 변화 감지하기

1. **watch를 사용한 자동 갱신**
```dart
@riverpod
class TotalCount extends _$TotalCount {
  @override
  int build() {
    // 다른 Provider들의 변화를 감지
    final count1 = ref.watch(counter1Provider);
    final count2 = ref.watch(counter2Provider);
    return count1 + count2;
  }
}
```

2. **listen을 사용한 사이드 이펙트 처리**
```dart
@riverpod
class NotificationHandler extends _$NotificationHandler {
  @override
  void build() {
    ref.listen(counterProvider, (previous, next) {
      if (next > 10) {
        showNotification('높은 숫자 경고!');
      }
    });
  }
}
```

### B.6. 자주 하는 실수와 해결 방법

1. **잘못된 예시**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ❌ 잘못된 방법: 직접 변수 수정
  int count = 0;
  void increment() {
    count++;  // state를 사용하지 않음
  }
}
```

2. **올바른 예시**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ✅ 올바른 방법: state 사용
  void increment() {
    state++;  // state를 통한 업데이트
  }
}
```

### B.7. 클래스형 Provider 사용 시 주의사항

1. **상태 업데이트**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  // ❌ 잘못된 방법
  void wrongUpdate() {
    build();  // build를 직접 호출하지 마세요
  }

  // ✅ 올바른 방법
  void correctUpdate() {
    state = 10;  // state 프로퍼티를 사용하세요
  }
}
```

2. **비동기 작업**
```dart
@riverpod
class DataLoader extends _$DataLoader {
  @override
  Future<String> build() async => '';

  // ❌ 잘못된 방법
  Future<void> wrongFetch() async {
    final data = await fetchData();
    state = data;  // 에러 처리가 없습니다
  }

  // ✅ 올바른 방법
  Future<void> correctFetch() async {
    state = const AsyncValue.loading();
    try {
      final data = await fetchData();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

3. **메모리 관리**
```dart
@riverpod
class ResourceManager extends _$ResourceManager {
  Timer? _timer;

  @override
  Stream<int> build() {
    // ✅ 올바른 방법: ref.onDispose로 정리
    ref.onDispose(() {
      _timer?.cancel();
    });

    _timer = Timer.periodic(/* ... */);
    return /* ... */;
  }
}
```

4. **상태 변경 시점**
```dart
@riverpod
class StateManager extends _$StateManager {
  @override
  int build() => 0;

  // ❌ 잘못된 방법
  void wrongInit() {
    state = 10;  // build 메서드 내에서 상태를 변경하지 마세요
  }

  // ✅ 올바른 방법
  void correctInit() {
    // 별도의 메서드에서 상태를 변경하세요
    Future.microtask(() => state = 10);
  }
}
```

> 💡 **주요 주의사항 요약**: 
> - build 메서드는 순수 함수여야 합니다 (side-effect가 없어야 함)
> - 상태 변경은 반드시 state 프로퍼티를 통해서만 해야 합니다
> - 비동기 작업은 항상 에러 처리를 포함해야 합니다
> - 리소스 정리는 ref.onDispose를 사용하세요
> - build 메서드 내에서는 직접적인 상태 변경을 하지 마세요



## 부록 C: build 함수 이해하기
[ㄴ B.2 : @riverpod 어노테이션 사용하기](#b2-riverpod-어노테이션-사용하기)
### C.1. build 함수가 필요한 이유
1. **초기 상태 설정**
   - Provider가 처음 사용될 때 상태의 초기값을 설정합니다.
   - 다른 Provider의 값을 참조하여 초기값을 계산할 수 있습니다.

2. **자동 정리(Auto-dispose)**
   - Provider가 더 이상 사용되지 않을 때 자동으로 정리됩니다.
   - 메모리 누수를 방지할 수 있습니다.

3. **의존성 추적**
   - build 함수 내에서 다른 Provider를 watch하면 자동으로 의존성이 추적됩니다.
   - 의존하는 Provider의 값이 변경되면 build 함수가 자동으로 다시 실행됩니다.

```dart
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<Map<String, dynamic>> build(ref) async {
    // 1. 다른 Provider 참조
    final userId = ref.watch(userIdProvider);
    
    // 2. 초기 데이터 로드
    final userData = await fetchUserData(userId);
    
    // 3. 초기값 반환
    return userData;
  }
}
```

## 부록 A : @riverpod 어노테이션 상세 사용법
[ㄴ 6. 상태관리 구현](#6-상태-관리-구현)

### A.1. 클래스 기반 Provider
```dart
// 1. 기본적인 상태 관리
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  void setValue(int value) => state = value;
}

// 2. 비동기 데이터 처리
@riverpod
class UserData extends _$UserData {
  @override
  Future<Map<String, dynamic>> build() async => {};

  Future<void> fetchUserData(String userId) async {
    state = const AsyncValue.loading();
    try {
      final response = await http.get(Uri.parse('api/users/$userId'));
      final data = jsonDecode(response.body);
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserName(String newName) async {
    state = const AsyncValue.loading();
    try {
      final currentData = state.value ?? {};
      final updatedData = {...currentData, 'name': newName};
      state = AsyncValue.data(updatedData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 3. 스트림 데이터 처리
@riverpod
class MessageStream extends _$MessageStream {
  @override
  Stream<List<String>> build() {        
    return Stream.periodic(
      const Duration(seconds: 1),
      (count) => ['Message $count'],
    );
  }

  void addMessage(String message) {
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([...currentMessages, message]);
  }

  void clearMessages() {
    state = const AsyncValue.data([]);
  }
}
```

### A.2. 함수 기반 Provider
```dart
// 1. 단순 값 제공
@riverpod
String greeting(ref) => 'Hello, World!';

// 2. 계산된 값 제공
@riverpod
int totalCount(ref) {
  final count1 = ref.watch(counter1Provider);
  final count2 = ref.watch(counter2Provider);
  return count1 + count2;
}

// 3. 비동기 데이터 가져오기
@riverpod
Future<List<String>> fetchItems(ref) async {
  final response = await http.get(Uri.parse('api/items'));
  return List<String>.from(jsonDecode(response.body));
}

// 4. 스트림 데이터 처리
@riverpod
Stream<int> countStream(ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (count) => count,
  ).take(10);
}

// 5. 매개변수를 받는 Provider
@riverpod
Future<Map<String, dynamic>> userProfile(ref, String userId) async {
  final response = await http.get(Uri.parse('api/users/$userId'));
  return jsonDecode(response.body);
}
```

> 💡 **참고하기**: 
> - 클래스형 Provider는 상태 관리가 필요한 복잡한 로직에 적합합니다
> - 함수형 Provider는 단순한 값이나 계산된 값을 제공할 때 사용합니다
> - 비동기 작업은 항상 에러 처리를 포함해야 합니다
> - state는 Provider의 현재 상태를 나타내며, 이를 통해서만 상태를 업데이트해야 합니다
