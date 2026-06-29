# Skill Selection Trace

> Profile에 포함된 skill과 preview 노출 방식을 기록한 dry-run example이다. Skill 설치나 실행 결과가 아니다.

## Profile 포함 Skill

### Common Skill — 7개

| Skill ID | 역할 | Load 기준 |
| --- | --- | --- |
| `common-incremental-implementation` | 복합 작업 단계 분리 | 큰 변경에서 load |
| `common-debugging` | 재현과 원인 분석 | 오류·실패 분석에서 load |
| `common-test-first` | 기대 동작과 회귀 검증 | 동작 변경에서 load |
| `common-code-review` | 정확성·설계·보안 검토 | Review 요청에서 load |
| `common-refactoring` | 동작 보존 구조 개선 | 명시적 refactoring에서 load |
| `common-security-review` | 입력·경로·command·secret 검토 | 신뢰 경계 변경에서 load |
| `common-commit-worklog` | Git-auto 작업 요약과 종료 정책 | Git-auto 저장소 종료 시 load |

### Testing 및 Automation — 각 1개

| Skill ID | 역할 | Load 기준 |
| --- | --- | --- |
| `testing-test-scope-selection` | Unit/integration 등 검증 범위 선택 | Test 범위 결정 시 load |
| `automation-git-auto-workflow` | Hook 실행과 publish pending 복구 | Git-auto 운영·실패 복구 시 load |

총 9개 path가 profile과 registry catalog에 일치한다.

## 상시 Gate와 필요 시 참조

상시 preview에는 incremental implementation, test-first, security review, commit-worklog와 test scope의 짧은 routing만 둔다. Debugging, code review, refactoring은 해당 작업에서만 참조한다.

`automation-git-auto-workflow`은 automation code 일반 구현 절차가 아니다. Git-auto hook 실행을 진단하거나 publisher 실패 후 pending을 재처리하는 요청에서만 읽는다. 일반 작업 종료 정책은 `common-commit-worklog`으로 충분하며 hook 설정을 임의 변경하지 않는다.

## Dependency 확인

- `common-refactoring` → `common-test-first`: 충족
- `testing-test-scope-selection` → `common-test-first`: 충족
- `automation-git-auto-workflow` → `common-commit-worklog`: 충족

## Inline 금지

Preview에는 skill ID, 짧은 역할과 trigger만 둔다. `SKILL.md`의 절차, checklist와 예시는 inline하지 않으며 profile에 포함됐다는 이유만으로 동시에 load하지 않는다.

## 결과

9개 skill의 path와 hard dependency가 충족된다. 실제 skill 설치·실행 또는 adapter mapping은 수행하지 않았다.
