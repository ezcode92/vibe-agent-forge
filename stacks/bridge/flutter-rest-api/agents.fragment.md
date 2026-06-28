# Flutter–REST API Bridge Fragment

## 목적

Flutter app의 mobile network·UI lifecycle을 REST API의 contract, 오류, 인증과 versioning에 연결한다. Flutter widget과 REST 설계의 일반 원칙은 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-flutter-rest-api`
- 필수 stack: `mobile-flutter`, `api-restful-api`
- 제외 조건: Remote API를 사용하지 않거나 Flutter 또는 RESTful API 중 하나만 선택된 구성

## 핵심 규칙

- Mobile network는 지연, 단절, 중복, 순서 변경과 app lifecycle 중단이 가능한 경계로 취급하고 UI에 진행·오프라인·재시도 상태를 제공한다.
- Retry는 method의 멱등성, 요청 식별자, 최대 횟수와 backoff를 고려하고 사용자 동작을 중복 생성하지 않게 한다.
- Transport DTO와 app/domain model을 분리해 null/부재, enum, 날짜와 version 차이를 mapping 경계에서 검증한다.
- Auth token의 획득·보안 저장·전송·갱신·폐기 책임을 집중시키고 widget이 token 값을 직접 관리하지 않게 한다.
- API version 및 field 호환성은 app release가 server보다 느리게 배포·업데이트될 수 있음을 전제로 관리한다.
- Offline data가 있으면 source, freshness, conflict와 재동기화 결과를 명시하고 server 성공으로 오인하지 않는다.

## 권장 패턴

- Network error, protocol error와 application error를 구분해 UI가 재시도·수정·재인증 동작을 결정하게 한다.
- Request 취소 또는 stale result 무시 정책을 화면 lifecycle 및 중복 요청과 연결한다.
- DTO mapping 실패는 불완전한 model로 숨기지 않고 contract/version 진단이 가능한 오류로 처리한다.
- Token 갱신은 동시 요청에서 하나의 흐름으로 조정하고 실패 시 local credential과 session state를 일관되게 정리한다.

## 금지 패턴

- 모든 network 실패를 자동 무한 재시도하거나 비멱등 요청을 확인 없이 반복하지 않는다.
- API response map을 widget에서 직접 읽거나 DTO를 mutable UI state model로 그대로 사용하지 않는다.
- Token을 log, 일반 설정 또는 widget tree를 통해 전달하지 않는다.
- Offline cache를 최신 server data로 표시하거나 conflict 정책 없이 background sync를 수행하지 않는다.
- 오래된 app version이 즉시 실패하도록 server contract를 공존 기간 없이 제거하지 않는다.

## 검증 기준

- Offline, timeout, 부분 응답, 중복 요청과 app lifecycle 변경 시 UI 결과가 예측 가능하다.
- Retry가 멱등성과 제한 정책을 지키며 중복 side effect를 만들지 않는다.
- DTO/model mapping이 정상·누락·추가·알 수 없는 값과 version 차이를 검증한다.
- Token 갱신·만료·폐기와 동시 요청 흐름이 안전하게 test된다.
- 지원 app/API version 범위와 deprecation·강제 update 기준이 명시된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Mobile API resilience, mapping 또는 auth lifecycle review skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `mobile-flutter`와 `api-restful-api`가 모두 선택되고 app이 remote REST API를 사용할 때 적용한다.
- Dart model과 serialization 세부 연결이 필요하면 `dart-flutter` 및 관련 product-specific bridge를 함께 검토한다.
