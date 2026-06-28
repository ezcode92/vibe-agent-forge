# React–Spring API Bridge Fragment

## 목적

React frontend와 Spring 기반 REST API 사이의 request·response·error, 인증 상태와 목록 조회 계약을 연결한다. React UI, Spring component와 REST 원칙 자체는 반복하지 않는다.

## 적용 대상

- Bridge 식별자: `bridge-react-spring-api`
- 필수 stack: `frontend-react`, `framework-spring`, `api-restful-api`
- 제외 조건: Client와 server가 해당 계약을 공유하지 않거나 세 stack 중 하나가 선택되지 않은 구성

## 핵심 규칙

- Request/response field의 이름, 타입, null/부재, 날짜·시간과 enum 의미를 양쪽에서 하나의 versioned contract로 검증한다.
- Spring 오류 변환과 React API client는 동일한 error code, field 오류와 추적 식별자 schema를 공유하며 UI message와 내부 진단 정보를 구분한다.
- 인증 credential의 생성·저장·전송·갱신·폐기 책임을 client, server와 사용자 session 경계별로 명시한다.
- 인증 실패와 권한 부족을 구분하고 token 갱신 중 동시 요청, 만료와 재시도 결과가 무한 loop를 만들지 않게 한다.
- Pagination/filter/sort의 parameter, 기본값, 허용 field, 안정된 순서와 metadata를 client/server 계약으로 고정한다.
- CORS는 browser가 강제하는 server-side 허용 정책으로 다루고 client workaround나 과도한 origin 허용으로 해결하지 않는다.

## 권장 패턴

- Contract 변경은 양쪽 배포 순서와 호환 구간을 포함하고 additive 변경을 우선 검토한다.
- React API client에서 transport error를 안정된 application error로 정규화하고 component는 wire schema를 직접 해석하지 않는다.
- Session/token 갱신은 단일 책임 경계에서 직렬화하고 실패 시 credential 정리와 사용자 상태 전환을 일관되게 수행한다.
- Contract test는 대표 정상·validation·인증·충돌·목록 조회 응답을 양쪽 기대와 대조한다.

## 금지 패턴

- Backend entity 또는 exception 구조를 response로 직접 노출하고 frontend가 그 내부 형태에 의존하게 하지 않는다.
- HTTP status만으로 모든 UI 오류 의미를 추론하거나 서로 다른 error schema를 endpoint마다 만들지 않는다.
- 장기 credential을 일반 UI state, log 또는 접근 범위가 넓은 저장소에 노출하지 않는다.
- CORS 오류를 전체 origin·method·credential 허용으로 일괄 해결하지 않는다.
- Client와 server가 pagination index, sort 또는 filter 문법을 서로 다르게 해석하게 하지 않는다.

## 검증 기준

- Request/response/error contract가 React client와 Spring server에서 동일하게 해석된다.
- 인증 만료, 갱신 성공·실패, 동시 요청과 권한 부족 흐름이 경계별로 검증된다.
- Pagination/filter/sort의 기본값, 제한과 결과 순서가 contract test에 포함된다.
- 허용 origin, credential과 header 정책이 최소 범위이며 환경별 책임이 명시된다.
- 호환되지 않는 변경에는 versioning, 배포 순서와 migration 계획이 있다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Frontend–backend contract 또는 auth flow review skill이 registry에 등록된 이후 해당 조건에서만 참조한다.

## Bridge 필요 조건

- `frontend-react`, `framework-spring`, `api-restful-api`가 모두 선택되고 양쪽이 직접 계약을 공유할 때 적용한다.
- Persistence schema와 API model의 연계가 필요하면 `spring-rdb` 등 database bridge를 별도로 선택한다.
