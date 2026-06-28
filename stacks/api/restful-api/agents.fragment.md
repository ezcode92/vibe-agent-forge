# RESTful API Fragment

## 목적

RESTful API의 resource, HTTP 의미, request·response·error 계약, 목록 조회와 versioning에 공통으로 적용할 원칙을 정의한다. Server/client framework, 언어와 database 구현은 다루지 않는다.

## 적용 대상

- Stack 식별자: `api-restful-api`
- 적용 조건: HTTP 기반 resource API를 설계, 변경 또는 검토하는 시스템
- 제외 조건: Framework routing 코드, client 상태 관리와 내부 persistence model

## 핵심 규칙

- URI는 처리 동사보다 resource와 관계를 표현하고 naming 및 복수형 정책을 API 전체에서 일관되게 유지한다.
- HTTP method의 안전성, 멱등성과 부분·전체 변경 의미를 지키며 실제 동작과 다른 method를 편의상 사용하지 않는다.
- Status code는 처리 결과를 정확히 나타내고 성공, client 오류, 인증·인가, 부재, 충돌과 server 실패를 구분한다.
- Request와 response는 필수값, null/부재, 형식, 기본값과 호환성 의미를 명시한 외부 계약으로 관리한다.
- Error response는 안정된 error code, 사용자에게 안전한 message, field 오류와 추적 식별자의 구조를 일관되게 유지한다.
- Pagination, filter와 sort는 허용 field, 기본값, 최대 크기, 안정된 순서와 page 이동 중 데이터 변경 영향을 정의한다.
- Versioning은 호환 불가능한 변경의 마지막 수단으로 사용하고 deprecation, 공존 기간과 client migration 정책을 함께 둔다.

## 권장 패턴

- Resource 생성·수정에는 중복 요청, 조건부 변경과 경쟁 update의 결과를 명시한다.
- 목록 response에는 items와 다음 조회에 필요한 metadata를 제공하되 내부 저장 구조를 노출하지 않는다.
- Contract 변경 전에 기존 client 영향과 additive 대안을 검토하고 예제보다 machine-readable 계약을 기준으로 삼는다.
- 인증 주체가 resource에 수행할 수 있는 동작을 endpoint마다 검증하고 오류 응답에 민감정보를 포함하지 않는다.

## 금지 패턴

- 모든 작업을 `POST`나 동사형 URI로 표현하지 않는다.
- 실패를 성공 status로 감싸거나 서로 다른 오류를 하나의 일반 code로 축소하지 않는다.
- 내부 entity, exception, stack trace와 storage 식별자를 외부 response에 그대로 노출하지 않는다.
- 정렬 기준 없는 offset/page 조회나 제한 없는 page size를 제공하지 않는다.
- 기존 field의 의미나 타입을 version 변경 없이 호환 불가능하게 바꾸지 않는다.

## 검증 기준

- URI와 method가 resource 및 안전성·멱등성 의미와 일치한다.
- 정상·경계·실패별 status와 request/response/error 계약이 문서화된다.
- Pagination, filter, sort가 결정적이며 허용 범위와 비용 제한을 가진다.
- Contract 변경의 하위 호환성, versioning과 deprecation 계획을 검토했다.
- Framework 구현과 독립적인 contract test 또는 동등한 검증 근거가 있다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: API design review 또는 contract compatibility skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Server framework의 routing·validation·exception 처리를 REST 계약에 연결할 때 framework–API bridge가 필요하다.
- Client의 상태·오류 처리를 REST 계약에 연결하거나 service 간 통신 정책을 정할 때 client/architecture–API bridge가 필요하다.
