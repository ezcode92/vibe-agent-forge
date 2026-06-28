# Dart–Flutter Bridge Fragment

## 목적

Dart의 null safety, Future·Stream과 model을 Flutter의 widget state 및 UI lifecycle에 연결하는 조합 규칙을 정의한다. Dart와 Flutter의 단독 규칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-dart-flutter`
- 필수 stack: `language-dart`, `mobile-flutter`
- 제외 조건: Dart 또는 Flutter 중 하나만 선택된 구성

## 핵심 규칙

- Widget state의 값 부재와 loading·empty·failure 상태를 Dart null 하나로 합치지 않고 UI가 구분 가능한 model로 표현한다.
- `late`와 강제 unwrap은 widget lifecycle에서 초기화가 실제 보장되는지 확인하고 dispose 이후 접근 가능성까지 검토한다.
- Future 결과는 widget의 현재 lifecycle과 요청 세대를 확인한 뒤 state에 반영하고 완료 전에 dispose될 수 있음을 처리한다.
- Stream subscription은 state 소유자와 lifecycle을 같이하며 교체·dispose 시 이전 subscription을 취소한다.
- Domain/API model은 widget 표현 책임과 분리하고 UI 편의를 위한 mutable field나 controller를 model에 넣지 않는다.

## 권장 패턴

- Async UI 상태는 값, 진행, 오류와 재시도 가능성을 명시하는 안정된 표현으로 관리한다.
- Widget 생성 시 필요한 값과 lifecycle 중 나중에 채워지는 값을 구분해 nullability 계약을 설계한다.
- Future/Stream callback은 stale result와 중복 event가 현재 화면에 미치는 영향을 검토한다.
- Model 변환과 validation은 widget 밖 경계에 두고 widget test와 model test를 분리한다.

## 금지 패턴

- UI의 모든 미결정 상태를 nullable field와 `!` 조합으로 표현하지 않는다.
- Dispose 여부를 확인하지 않은 async callback에서 state를 갱신하지 않는다.
- Stream subscription, controller와 listener의 소유자를 불명확하게 두지 않는다.
- Widget에 serialization, model mutation과 원격 데이터 변환 책임을 함께 넣지 않는다.

## 검증 기준

- Null, loading, empty, failure와 success 상태가 UI에서 명확히 구분된다.
- Future와 Stream의 완료·오류·취소 및 dispose 경로가 widget lifecycle test로 검증된다.
- Model과 widget 책임이 분리되고 데이터 변환은 독립 test 가능하다.
- `late`와 강제 unwrap마다 lifecycle상 안전한 근거가 확인된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Dart–Flutter async UI 또는 lifecycle 진단 skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `language-dart`와 `mobile-flutter`가 모두 선택될 때만 적용한다.
- Remote API와 model/version 계약까지 연결하면 `flutter-rest-api` bridge를 추가로 선택한다.
