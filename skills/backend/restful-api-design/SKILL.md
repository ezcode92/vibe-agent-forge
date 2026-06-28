---
name: restful-api-design
description: Backend use case를 resource 중심 RESTful API 계약으로 설계하고 method·status, request·response·error, 목록 조회와 versioning을 구체화한다. 신규 backend endpoint 또는 호환성 변경을 설계할 때 사용한다.
---

# RESTful API Design

## 목적

Backend capability를 소비자가 안정적으로 사용할 수 있는 RESTful 계약으로 설계하고 application 경계와 외부 표현을 분리한다. 특정 server framework, controller 코드와 serialization library는 다루지 않는다.

## 사용 조건

- 신규 resource API 또는 기존 계약 변경을 설계할 때 적용한다.
- Consumer, use case, 권한과 하위 호환성 요구를 먼저 확인한다.
- 기존 설계 review만 필요한 경우 common `api-design-review`를 우선 검토한다.

## 입력 Context

- Backend use case, resource lifecycle과 권한 정책
- 기존 endpoint, consumer와 API version
- Request/response/error 요구와 domain 실패
- Pagination, filter, sort 및 성능 제한

## 작업 절차

1. Consumer 목적과 resource·subresource 경계를 정의한다.
2. URI, method와 멱등성·안전성 의미를 operation에 연결한다.
3. 정상·생성·삭제·비동기 처리와 주요 실패별 status를 정한다.
4. Request/response의 field, 필수값, null/부재, 형식과 외부 model을 정의한다.
5. Validation, 인증·인가, 부재, 충돌과 server 실패를 일관된 error contract로 mapping한다.
6. Pagination 방식, filter/sort 허용값, 기본값, 최대 크기와 안정된 순서를 정한다.
7. Additive 변경 가능성을 먼저 검토하고 불가하면 versioning·deprecation·consumer migration을 설계한다.
8. Contract example과 framework 독립 검증 시나리오를 작성한다.

## 검증 기준

- Resource, method와 status가 backend use case 및 HTTP 의미와 일치한다.
- 내부 domain/persistence model이 외부 contract에 그대로 누출되지 않는다.
- Error code와 field 오류가 domain 실패를 안정적으로 표현한다.
- Pagination/filter/sort가 결정적이고 제한된 비용 경계를 가진다.
- 기존 consumer의 호환성과 version 전환 계획을 확인할 수 있다.

## 금지 패턴

- Controller 구현 편의를 resource와 contract 설계 근거로 사용하지 않는다.
- 모든 operation을 동사형 URI 또는 하나의 method로 표현하지 않는다.
- 내부 exception과 entity를 response로 직접 노출하지 않는다.
- 무제한 목록 조회나 안정된 정렬 없는 pagination을 설계하지 않는다.

## 완료 기준

- Resource, endpoint와 request/response/error 계약이 명시된다.
- 권한, 목록 조회와 versioning 요구가 반영된다.
- Consumer 및 framework 독립 contract 검증 기준이 정의된다.
- 미확정 backend policy와 호환성 위험이 보고된다.

## 참고 문서

- `stacks/api/restful-api/agents.fragment.md`
- `skills/common/api-design-review/SKILL.md`
- 선택된 API bridge fragment
