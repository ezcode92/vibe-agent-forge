# CLI Automation Architecture Fragment

## 목적

CLI와 automation 프로젝트에서 command 진입점, 핵심 판단과 외부 side effect의 책임을 분리하고 batch·one-shot·workflow 실행을 예측 가능하게 유지하는 architecture 원칙을 정의한다. 특정 언어, CLI framework, package manager, scheduler와 CI 제품은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-cli-automation`
- 적용 조건: 사용자 command, batch 작업 또는 자동화 workflow가 filesystem, network나 외부 process와 상호작용하는 프로젝트
- 제외 조건: Web request lifecycle, mobile UI lifecycle 또는 장기 실행 server가 주 실행 모델인 시스템

## 핵심 규칙

- Command entrypoint는 argument와 option을 해석하고 실행 결과를 전달하는 얇은 경계로 두며 domain/service 판단을 직접 소유하지 않게 한다.
- Configuration, command input, domain/service input과 output 표현을 구분하고 외부 형식을 핵심 로직의 내부 model로 그대로 확산하지 않는다.
- Filesystem, network와 process 실행은 명시적인 side effect 경계 뒤에 두고 호출 조건, timeout, 실패와 resource 정리 책임을 드러낸다.
- 재실행 가능한 작업은 idempotency 기준을 정의하고 retry가 중복 변경이나 외부 side effect를 만들지 않는 조건을 명시한다.
- Diagnostic logging과 user-facing output을 구분해 log 세부사항, machine-readable 결과와 사용자 message가 서로의 계약을 대신하지 않게 한다.
- 즉시 종료하는 one-shot command, 여러 항목을 처리하는 batch와 단계·상태를 이어 가는 automation workflow의 실행·실패·재개 의미를 구분한다.
- 핵심 판단은 command parser, 환경 상태와 외부 adapter 없이 검증 가능하게 하고 side effect 경계는 대체 가능한 test seam을 제공한다.

## 권장 패턴

- Entry point는 입력 변환, use case 호출, 결과를 exit status와 output으로 변환하는 흐름만 조정한다.
- Batch는 항목별 성공·실패, 부분 완료와 재처리 기준을 기록하고 전체 성공 여부를 명확히 계산한다.
- Workflow는 단계별 선행 조건, 산출물, 중단·재개와 중복 실행 정책을 명시한다.
- Side effect adapter는 목적별로 좁게 두고 실제 변경을 수행하기 전에 검증 또는 dry-run이 필요한 경계를 구분한다.
- 작은 CLI는 function과 module의 직접적인 책임 분리로 시작하고 변화 축이 확인될 때만 추가 abstraction을 도입한다.

## 금지 패턴

- Command handler 하나에 parsing, business rule, filesystem·network·process 호출과 output formatting을 모두 모으지 않는다.
- Retry 가능 여부를 구분하지 않고 모든 실패를 반복하거나 부분 성공을 전체 성공으로 보고하지 않는다.
- User-facing output을 유일한 diagnostic log로 사용하거나 내부 stack·credential과 민감한 실행 값을 사용자 출력에 노출하지 않는다.
- Batch와 workflow의 중간 상태를 숨긴 채 실패 후 처음부터 안전하게 재실행할 수 있다고 가정하지 않는다.
- 작은 command에 고정된 layer 수, interface, repository와 범용 workflow engine을 형식적으로 추가하지 않는다.

## 검증 기준

- Entrypoint, 핵심 판단, configuration/input/output과 side effect 경계의 책임을 설명할 수 있다.
- Filesystem, network와 process 실패 및 resource 정리 결과를 독립적으로 검증할 수 있다.
- One-shot, batch와 workflow별 성공, 부분 실패, retry와 재개 의미가 명시된다.
- Logging, user-facing output, machine-readable output과 exit status의 계약이 구분된다.
- 핵심 로직이 외부 환경 없이 test 가능하고 추가 abstraction마다 실제 변화 축 또는 격리 근거가 있다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Automation workflow, debugging, test scope와 security review skill은 해당 작업 trigger가 있을 때만 참조한다.

## Bridge 필요 조건

- 특정 언어의 command model, async 또는 resource 규칙을 architecture 경계에 연결할 별도 의미가 있을 때만 language bridge를 검토한다.
- Scheduler, CI, cloud runner나 특정 CLI framework의 lifecycle을 연결하는 규칙은 product 선택이 확정된 profile 또는 bridge에서 다룬다.
