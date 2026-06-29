# Manual Validation Report

> `fullstack-spring-react` + Codex dry-run에 adapter validation 계약을 수동 적용한 example이다. Validator 실행 결과가 아니다.

## Summary

| 항목 | 결과 |
| --- | --- |
| Profile | `fullstack-spring-react` |
| Adapter | `codex` (`mvp-contract`) |
| Overall status | `failed` |
| Preview status | `blocked` |
| Error | 1 |
| Warning | 0 |
| File write | 수행하지 않음 |

## Check 결과

| Check | Severity | Status | 근거와 결과 |
| --- | --- | --- | --- |
| Profile YAML parse | Info | Passed | Manifest가 parse되고 profile ID, variant와 constraint를 식별함 |
| Registry YAML parse | Info | Passed | Fragment, skill, profile, adapter와 compatibility catalog가 parse됨 |
| Required fragment path existence | Info | Passed | 공통 13개와 두 variant 후보의 fragment·bridge 4개 path가 존재함 |
| Required skill path existence | Info | Passed | Profile skill 20개 path가 모두 존재함 |
| Common required bridge resolved | Info | Passed | Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API bridge가 선택되고 dependency가 충족됨 |
| Backend language selection | Error | Failed | `exactly-one` 필수 variant에서 Java/Kotlin option이 선택되지 않아 대응 Spring bridge를 확정할 수 없음 |
| Variant candidate integrity | Info | Passed | Java + Java–Spring, Kotlin + Kotlin–Spring 두 묶음의 path·dependency·compatibility가 각각 유효함 |
| Adapter template path existence | Info | Passed | Codex template path가 존재하고 `mvp-contract` 호환 상태임 |
| Output section completeness | Info | Diagnostic only | Partial preview에 8개 section이 있으나 필수 variant 미해소로 완성 preview가 아님 |
| Output size budget compliance | Info | Passed | Partial preview가 300 lines, 24 headings, 4,000 estimated tokens 목표 안이고 skill body inline이 없음 |
| Protected file untouched | Info | Passed | Root/global AGENTS, hook과 `.gitauto/`를 adapter output으로 쓰지 않음 |
| Unsupported feature warning | Info | Passed | 실제 export, skill 설치와 hook 병합을 profile output으로 요구하지 않아 warning 없음 |

## Variant Error 근거

`backend_language`는 optional 추천이 아니라 `required: true`, `selection: exactly-one`이다. Profile constraint는 선택 language fragment와 대응 Spring bridge를 함께 적용하도록 요구하고 미선택 상태를 최종 조합으로 간주하지 않는다. Codex adapter 계약도 required variant와 bridge가 해소되기 전 preview를 차단한다.

Java나 Kotlin을 기본값으로 추정하지 않았으며 두 option을 동시에 병합하지 않았다. 다음 검증에서 project 입력으로 option 하나를 선택하면 이 error를 재평가할 수 있다.

## Output Size

측정 대상인 진단용 `AGENTS.preview.md`는 102 lines, 15 headings, 5,265 characters와 약 1,755 estimated tokens다. `docs/output-size-budget.md` 및 profile의 300/24/4,000 목표 안에 있다. 실제 tokenizer 또는 validator 구현을 의미하지 않는다.

## Readiness

공통 source, dependency, bridge, skill과 두 variant 후보는 유효하지만 required backend language가 선택되지 않았다. Error 1개로 최종 상태는 `blocked`다. `AGENTS.preview.md`는 partial diagnostic example이며 완성 preview 또는 실제 export 가능한 설정이 아니다.
