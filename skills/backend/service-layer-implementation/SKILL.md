---
name: service-layer-implementation
description: Backend service layer의 use case, business rule, transaction 후보와 controller·repository 경계를 분석하고 최소 단위로 구현·검증한다. Service 책임을 새로 추가하거나 기존 service 흐름을 변경할 때 사용한다.
---

# Service Layer Implementation

## 목적

Service layer가 application use case를 조정하고 business rule과 외부 경계의 책임을 명확히 유지하도록 구현 절차를 제공한다. 특정 framework annotation, 언어 문법과 persistence 제품 사용법은 다루지 않는다.

## 사용 조건

- Backend use case의 추가·변경이 service 책임에 영향을 줄 때 적용한다.
- 단순 입력 변환이나 저장소 단일 위임이면 새 service abstraction이 필요한지 먼저 검토한다.
- 구현 권한이 없는 설계·review 요청에서는 변경하지 않고 책임과 후보 경계만 제시한다.

## 입력 Context

- Use case, 입력·출력, business invariant와 실패 결과
- 기존 controller, service, domain과 repository 책임
- Transaction, 외부 호출과 권한 경계
- 관련 test, 공개 API와 프로젝트 architecture 지침

## 작업 절차

1. Use case의 시작 조건, 결과, 실패와 변경되는 상태를 정의한다.
2. Business rule이 domain, service 또는 외부 policy 중 어디에 속하는지 변경 이유와 불변식으로 판단한다.
3. Controller의 transport 책임과 repository의 persistence 책임을 제외한 service 조정 책임을 정한다.
4. 함께 성공·실패해야 하는 상태 변경을 식별해 transaction boundary 후보를 표시한다.
5. 외부 API, message와 장시간 작업을 transaction 후보에서 분리하고 부분 실패 정책을 정한다.
6. 가장 작은 service operation과 명시적 dependency로 구현한다.
7. Business rule, 협력 순서, transaction 결과와 실패 경로를 관련 수준의 test로 검증한다.

## 검증 기준

- Service operation이 하나의 use case와 관찰 가능한 결과를 가진다.
- Business rule이 controller 또는 repository에 중복되지 않는다.
- Transaction 후보와 외부 side effect 경계가 설명된다.
- 정상, validation, business 실패와 dependency 실패가 검증된다.
- 공개 계약과 인접 use case에 의도하지 않은 회귀가 없다.

## 금지 패턴

- 모든 business rule을 service 조건문에 집중시키지 않는다.
- Controller가 transaction과 repository 호출 순서를 직접 조정하게 하지 않는다.
- Repository에 권한·workflow와 외부 호출 책임을 넣지 않는다.
- 단순 위임만 하는 계층이나 범용 manager를 근거 없이 추가하지 않는다.

## 완료 기준

- Service, controller, domain과 repository 책임이 구분된다.
- Transaction 및 실패 경계가 구현 또는 설계 결과에 반영된다.
- 관련 test와 프로젝트 검증이 통과하거나 미실행 사유가 보고된다.
- 남은 architecture 결정과 후속 작업이 구분된다.

## 참고 문서

- `core/quality/agents.fragment.md`
- `skills/common/incremental-implementation/SKILL.md`
- 선택된 framework 및 architecture fragment
