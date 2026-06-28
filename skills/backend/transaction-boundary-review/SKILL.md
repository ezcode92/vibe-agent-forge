---
name: transaction-boundary-review
description: Backend operation의 read/write, 외부 호출, retry·idempotency와 nested transaction을 분석해 transaction 시작·종료 및 실패 경계를 검토한다. 상태 변경 흐름이나 transaction 설정을 설계·변경할 때 사용한다.
---

# Transaction Boundary Review

## 목적

하나의 business operation에 필요한 원자성과 일관성을 최소 transaction 범위로 보장하고 외부 side effect와 재시도 위험을 분리한다. 특정 framework annotation과 database 제품의 격리 구현은 다루지 않는다.

## 사용 조건

- 여러 읽기·쓰기 또는 외부 연동이 하나의 operation에 포함될 때 적용한다.
- Transaction 필요성, 일관성 수준과 실패 결과를 use case로 확인한다.
- 실제 지원 기능은 선택된 framework/database 문서에서 별도로 검증한다.

## 입력 Context

- Operation의 읽기·쓰기 순서와 보호할 invariant
- Repository, 외부 API, message와 비동기 경계
- 실패·timeout·retry 및 중복 요청 정책
- 기존 transaction 전파, lock과 관련 test

## 작업 절차

1. 함께 commit 또는 rollback되어야 하는 상태 변경과 관찰 가능한 결과를 식별한다.
2. Read-only와 write operation을 구분하고 read/write routing 시 consistency 요구를 확인한다.
3. Transaction 시작·종료 후보를 호출 경로에 표시하고 connection·lock 점유 시간을 검토한다.
4. 외부 API와 장시간 작업을 transaction 밖으로 이동할 수 있는지 검토하고 부분 실패 보상 경계를 정한다.
5. Retry 가능한 실패와 불가능한 실패를 구분하고 operation의 idempotency 또는 중복 방지 조건을 확인한다.
6. Nested transaction 요구가 독립 commit 필요인지 단순 호출 구조 문제인지 검토한다.
7. 동시성, rollback, retry와 외부 실패를 포함한 검증 시나리오를 정리한다.

## 검증 기준

- Transaction 범위가 business invariant 및 실제 호출 경로와 일치한다.
- Read/write 분리 시 stale read와 write 후 read 결과가 정의된다.
- 외부 호출 실패가 database transaction을 불필요하게 장시간 유지하지 않는다.
- Retry가 idempotent하거나 명시적 중복 방지 장치를 가진다.
- Nested transaction과 propagation 선택에 구체적인 원자성 근거가 있다.

## 금지 패턴

- Service 전체나 모든 public method에 transaction을 관성적으로 적용하지 않는다.
- 외부 network 호출을 lock·connection 점유 상태에서 근거 없이 수행하지 않는다.
- 재시도를 중복 side effect와 분리하지 않은 채 추가하지 않는다.
- Nested transaction으로 잘못된 책임 경계와 exception 흐름을 숨기지 않는다.

## 완료 기준

- 시작·종료, commit·rollback과 외부 side effect 경계가 명확하다.
- Read/write, retry·idempotency와 nested transaction finding이 근거를 가진다.
- 동시성 및 실패 검증 시나리오가 정의되거나 실행 결과가 기록된다.
- Product-specific capability 확인 필요성이 별도 보고된다.

## 참고 문서

- `stacks/database/rdb/agents.fragment.md`
- `stacks/bridge/spring-rdb/agents.fragment.md`
- 선택된 framework/database의 공식 transaction 문서
