---
name: flutter-api-integration
description: Flutter app의 DTO/model mapping, network 오류·retry·offline, auth token lifecycle과 API version 호환성을 통합한다. Mobile screen이나 service가 REST API를 새로 사용하거나 계약 변경에 대응할 때 사용한다.
---

# Flutter API Integration

## 목적

Mobile network의 불안정성과 app release 주기를 고려해 API contract를 Flutter model·state에 안전하게 연결한다. 특정 HTTP client, serialization package와 secure storage 제품 API는 다루지 않는다.

## 사용 조건

- 신규 remote API 연동 또는 DTO/version 변경 시 적용한다.
- REST contract, offline 요구와 인증 정책을 먼저 확인한다.
- Client가 server 동작을 추정해야 하는 미확정 계약은 별도 위험으로 기록한다.

## 입력 Context

- Request/response/error와 API version contract
- DTO, app/domain model과 mapping 경계
- Network timeout, retry, offline/cache와 sync 정책
- Token 획득·저장·갱신·폐기 및 app lifecycle

## 작업 절차

1. Contract field, null/부재, enum, 날짜와 version을 DTO에 mapping할 기준을 확인한다.
2. DTO와 app/domain model의 책임을 분리하고 invalid·unknown 값을 처리한다.
3. Network, protocol, auth와 application error를 UI가 판단 가능한 결과로 정규화한다.
4. Retry 대상, 멱등성, 최대 횟수와 중복 side effect 방지 조건을 정한다.
5. Offline data의 source, freshness, conflict와 재동기화 정책을 정의한다.
6. Token의 보안 저장, 첨부, 갱신 동시성, 만료·logout과 폐기 흐름을 연결한다.
7. 구버전 app과 새 API의 공존, deprecation과 강제 update 기준을 검토한다.
8. 정상·mapping 실패·offline·retry·auth·version 시나리오를 test한다.

## 검증 기준

- DTO/model mapping이 누락·추가·unknown 값과 version 차이를 처리한다.
- Network 오류와 application 오류의 UI 결과가 구분된다.
- Retry가 제한되고 멱등성 및 중복 방지 조건을 지킨다.
- Offline freshness·conflict와 재동기화 결과를 예측할 수 있다.
- Token 갱신·만료·폐기 및 지원 API version 범위가 검증된다.

## 금지 패턴

- API response를 widget에서 직접 parsing하거나 DTO를 mutable UI model로 사용하지 않는다.
- 모든 network 실패를 자동 재시도하지 않는다.
- Token을 log, widget tree 또는 일반 설정에 노출하지 않는다.
- Offline cache를 최신 server 상태로 표시하거나 충돌을 조용히 덮어쓰지 않는다.

## 완료 기준

- DTO/model, network/error와 auth 경계가 정의된다.
- Offline·retry·version 정책이 app lifecycle과 연결된다.
- 주요 contract 및 실패 test가 통과한다.
- Server 미확정 사항과 platform별 저장 위험이 보고된다.

## 참고 문서

- `stacks/bridge/flutter-rest-api/agents.fragment.md`
- `skills/frontend/ui-error-handling/SKILL.md`
- 선택된 API contract 문서
