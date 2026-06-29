# Manual Validation Report

> `python-cli-automation` + Codex dry-run에 adapter validation 계약을 수동 적용한 example이다. Validator 실행 결과가 아니다.

## Summary

| 항목 | 결과 |
| --- | --- |
| Profile | `python-cli-automation` |
| Adapter | `codex` (`mvp-contract`) |
| Overall status | `passed-with-warnings` |
| Preview status | `ready-with-warnings` |
| Error | 0 |
| Warning | 1 |
| File write | 수행하지 않음 |

## Check 결과

| Check | Severity | Status | 근거와 결과 |
| --- | --- | --- | --- |
| Profile/catalog parse | Info | Passed | 대상 manifest와 registry catalog 구조를 수동 대조함 |
| Path existence | Info | Passed | Fragment 4개, skill 9개, adapter와 template path가 모두 존재함 |
| Dependency | Info | Passed | Fragment와 skill hard dependency가 선택 집합에서 충족됨 |
| Bridge/compatibility | Info | Passed | 조합상 required bridge가 없으며 profile도 bridge를 선택하지 않음 |
| Architecture fragment pending | Warning | Review required | CLI/automation architecture fragment가 없어 실제 module·command 책임 경계 결정이 남음 |
| Template/section | Info | Passed | Template의 8개 section을 유지하고 실제 설정이 아닌 preview임을 표시함 |
| Placeholder policy | Info | Passed | CLI framework, package manager와 validation command를 추정하지 않음 |
| Skill body inline | Info | Passed | Skill ID·역할·trigger만 요약하고 본문을 포함하지 않음 |
| Unsupported output | Info | Passed | 실제 file write, hook 병합과 skill 설치를 요구하지 않음 |
| Output size | Info | Passed | 공통 수동 budget의 300 lines, 24 headings, 4,000 estimated tokens 이하 |

## Warning 근거

`constraints.pending`의 `architecture-fragment`는 source 누락 error가 아니라 profile이 명시한 미결정 사항이다. Python 언어와 automation routing preview는 가능하지만 실제 project의 command/module 의존 방향을 확정할 수 없으므로 warning으로 분류한다. 임의의 architecture fragment를 선택하지 않는다.

## Output Size

측정 대상 `AGENTS.preview.md`는 92 lines, 14 headings, 3,241 characters와 약 1,081 estimated tokens다. `docs/output-size-budget.md`의 300/24/4,000 공통 목표 안에 있다. Profile의 `generator 확정 전 수동 검토` 문구는 이 수동 측정으로 보완했으며 tokenizer 또는 validator 구현을 의미하지 않는다.

## Readiness

Error는 없고 architecture에 관한 수동 결정 warning 1개가 남아 최종 상태는 `ready-with-warnings`다. Preview는 review용 example이며 실제 root `AGENTS.md` 또는 export 가능한 설정이 아니다.
