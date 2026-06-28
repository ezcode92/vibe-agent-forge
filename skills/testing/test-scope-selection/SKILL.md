---
name: test-scope-selection
description: 변경 책임과 위험에 맞춰 unit, integration, contract와 end-to-end test 범위를 선택하고 최소 검증에서 상위 검증으로 확장한다. 무엇을 어느 수준에서 test할지 결정하거나 검증 비용을 조정할 때 사용한다.
---

# Test Scope Selection

## 목적

변경된 동작을 가장 좁고 신뢰할 수 있는 test에서 검증하고, 경계와 전체 흐름 위험에 따라 통합 범위를 확장한다. 특정 test framework, runner와 mocking library 사용법은 다루지 않는다.

## 사용 조건

- 기능·버그·리팩터링 변경의 적절한 test 수준을 결정할 때 적용한다.
- 기존 test 전략과 프로젝트 명령을 우선한다.
- 실행 test가 불가능하면 대체 검증과 잔여 위험을 명시한다.

## 입력 Context

- 변경 책임, 공개 계약과 실패 가능성
- 관련 dependency, 외부 boundary와 데이터 흐름
- 기존 unit/integration/contract/e2e test
- 실행 시간, 환경과 test data 제약

## 작업 절차

1. 변경으로 달라지는 관찰 가능한 동작과 보호할 회귀를 정의한다.
2. Pure rule과 단일 책임은 unit test 후보로, 실제 boundary 결합은 integration/contract 후보로 분류한다.
3. 사용자 핵심 흐름과 여러 system 조합 위험만 e2e 후보로 선택한다.
4. 가장 좁은 관련 test를 먼저 실행하고 실패 원인을 변경과 연결한다.
5. Boundary, configuration와 contract 영향이 있으면 integration 또는 contract test로 확장한다.
6. 배포 수준의 핵심 흐름 위험이 남을 때 제한된 e2e 검증을 실행한다.
7. Test할 수 없는 항목은 정적 검사, review, 수동 재현 또는 관측 계획과 그 한계를 기록한다.

## 검증 기준

- 각 test 수준이 검증하는 책임과 실패 신호가 구분된다.
- Unit test가 외부 환경에 불필요하게 의존하지 않는다.
- Integration/contract test가 실제 boundary와 설정 차이를 검증한다.
- E2E test가 핵심 흐름에 한정되고 하위 test와 중복되지 않는다.
- 미실행 검증과 대체 검증의 신뢰 한계가 보고된다.

## 금지 패턴

- 모든 변경을 e2e test만으로 검증하지 않는다.
- 실제 boundary 동작을 unit mock의 기대 호출만으로 대체하지 않는다.
- Test 실행 시간이 짧다는 이유만으로 필요한 contract 검증을 생략하지 않는다.
- Test 불가 상태를 검증 성공으로 표현하지 않는다.

## 완료 기준

- 변경별 unit/integration/contract/e2e 선택 근거가 있다.
- 최소 검증부터 필요한 상위 검증까지 결과가 기록된다.
- 중복 test와 검증 공백이 식별된다.
- 대체 검증, 미실행 사유와 남은 위험이 명시된다.

## 참고 문서

- `skills/common/test-first/SKILL.md`
- `core/quality/agents.fragment.md`
- 프로젝트의 test 전략과 명령 문서
