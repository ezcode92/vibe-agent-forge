---
name: api-design-review
description: Framework와 무관하게 resource 중심 HTTP API의 목적, method·status 의미, request·response·error 계약과 pagination·versioning을 검토한다. 신규 API 설계 또는 호환성에 영향을 주는 API 변경을 review할 때 사용한다.
---

# API Design Review

## 목적

API가 사용자 use case와 안정된 외부 계약을 일관된 HTTP 의미로 표현하는지 검토한다. Framework routing, controller와 client 구현 방식은 다루지 않는다.

## 사용 조건

- API의 소비자, use case와 변경 목적을 확인한다.
- 신규 설계인지 기존 계약 변경인지 구분한다.
- API 유형이 RESTful HTTP가 아니면 해당 protocol의 별도 기준을 사용한다.

## 입력 Context

- API 목적, 주요 consumer와 권한 경계
- Resource, endpoint, method와 status 초안
- Request, response, error와 목록 조회 계약
- 기존 version, 호환성 정책과 관련 문서

## 작업 절차

1. Consumer가 달성하려는 결과와 resource 경계를 확인한다.
2. URI가 동작보다 resource와 관계를 표현하는지 검토한다.
3. HTTP method의 안전성·멱등성과 성공·실패 status가 실제 동작에 맞는지 확인한다.
4. Request/response의 필수값, null/부재, 형식과 하위 호환성을 검토한다.
5. Error code, message, field 오류와 추적 정보가 일관되고 민감정보를 노출하지 않는지 확인한다.
6. Pagination, filter, sort의 기본값, 제한, 안정된 순서와 비용 경계를 검토한다.
7. 호환되지 않는 변경의 versioning, deprecation과 consumer migration 계획을 확인한다.
8. Finding을 계약 위치, consumer 영향과 권장 수정 방향으로 정리한다.

## 검증 기준

- Resource, method와 status가 HTTP 의미 및 use case와 일치한다.
- 정상·경계·실패 계약을 consumer 관점에서 예측할 수 있다.
- 목록 조회가 결정적이고 제한되며 filter/sort 허용 범위가 명시된다.
- 변경의 하위 호환성 또는 version 전환 계획이 검증된다.
- Framework 독립 contract test나 동등한 검증 기준을 정의할 수 있다.

## 금지 패턴

- 모든 작업을 동사형 URI나 하나의 method로 표현하지 않는다.
- 내부 entity, exception과 storage 구조를 외부 계약으로 그대로 노출하지 않는다.
- 실패를 성공 status로 감싸거나 endpoint마다 다른 error 구조를 허용하지 않는다.
- 제한 없는 목록 조회와 불안정한 정렬을 승인하지 않는다.
- Framework 편의를 API 계약의 근거로 사용하지 않는다.

## 완료 기준

- API 목적과 resource 경계가 명확하다.
- Contract, error, 목록 조회와 versioning finding이 근거와 함께 정리된다.
- Blocking issue와 개선 제안이 구분된다.
- 미확정 consumer 요구와 남은 호환성 위험이 보고된다.

## 참고 문서

- `stacks/api/restful-api/agents.fragment.md`
- `docs/database-api-architecture-fragment-guide.md`
- `docs/skill-spec.md`
