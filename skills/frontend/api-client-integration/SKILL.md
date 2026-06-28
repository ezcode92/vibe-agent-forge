---
name: api-client-integration
description: Frontend API client의 request·response 계약, 오류 정규화, 목록 조회와 인증 session 경계를 UI 상태에 통합한다. React frontend가 backend API를 새로 사용하거나 계약 변경에 대응할 때 사용한다.
---

# API Client Integration

## 목적

API transport와 UI를 분리하고 contract, 오류, pagination과 인증 lifecycle을 일관된 client 경계로 통합한다. 특정 HTTP client library와 backend framework 구현은 다루지 않는다.

## 사용 조건

- 신규 endpoint 연동 또는 request/response 계약 변경 시 적용한다.
- API 명세, 인증 정책과 consumer 요구를 먼저 확인한다.
- Server contract가 불명확하면 client 추정으로 고정하지 않고 확인 필요 사항을 기록한다.

## 입력 Context

- Endpoint, method, request/response/error contract
- Pagination, filter, sort와 versioning 정책
- Auth token/session의 생성·갱신·폐기 책임
- UI의 loading, empty, error와 stale 상태 요구

## 작업 절차

1. Request field, null/부재, 형식과 response shape를 server contract와 대조한다.
2. Transport DTO를 UI/domain model로 변환할 경계와 validation 실패 처리를 정한다.
3. Network, protocol, authentication, validation과 application error를 안정된 client error로 정규화한다.
4. Pagination cursor/page, filter/sort parameter, 기본값과 결과 metadata를 연결한다.
5. Token/session의 저장·첨부·갱신·만료·logout 책임을 component 밖 경계에 둔다.
6. 중복 요청, 취소, stale response와 retry의 UI 결과를 정의한다.
7. Contract 정상·오류·인증·목록 조회 시나리오를 test한다.

## 검증 기준

- Request/response/error가 server contract와 동일하게 해석된다.
- Component가 endpoint, header와 wire schema를 직접 소유하지 않는다.
- Pagination/filter/sort가 안정된 순서와 server 제한을 따른다.
- Token 갱신, 만료, 동시 요청과 logout 결과가 일관된다.
- Loading, empty, error와 stale response 처리가 검증된다.

## 금지 패턴

- Response shape를 확인 없이 UI model로 단언하거나 component에서 직접 parsing하지 않는다.
- 모든 오류를 일반 message 하나로 축소하지 않는다.
- Token을 일반 UI state, log 또는 광범위한 storage에 노출하지 않는다.
- Retry 가능성과 멱등성을 확인하지 않고 요청을 자동 반복하지 않는다.

## 완료 기준

- Client boundary와 DTO/model mapping이 정의된다.
- Error, 목록 조회와 auth lifecycle이 UI 상태에 연결된다.
- Contract 및 주요 실패 test가 통과하거나 미실행 사유가 보고된다.
- Version·호환성 및 server 미확정 사항이 명시된다.

## 참고 문서

- `stacks/bridge/react-spring-api/agents.fragment.md`
- `skills/frontend/ui-error-handling/SKILL.md`
- 선택된 API contract 문서
