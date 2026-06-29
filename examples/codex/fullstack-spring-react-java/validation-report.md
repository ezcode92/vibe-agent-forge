# Manual Validation Report

> `fullstack-spring-react` Java variant + Codex dry-run에 adapter validation 계약을 수동 적용한 example이다. Validator 실행 결과가 아니다.

## Summary

| 항목 | 결과 |
| --- | --- |
| Profile | `fullstack-spring-react` |
| Backend language variant | `java` |
| Adapter | `codex` (`mvp-contract`) |
| Overall status | `passed` |
| Preview status | `ready` |
| Error | 0 |
| Warning | 0 |
| File write | 수행하지 않음 |

## Check 결과

| Check | Severity | Status | 근거와 결과 |
| --- | --- | --- | --- |
| Profile YAML parse | Info | Passed | Manifest가 parse되고 profile ID, Java variant와 constraint를 식별함 |
| Registry YAML parse | Info | Passed | Fragment, skill, profile, adapter와 compatibility catalog가 parse됨 |
| Required fragment path existence | Info | Passed | 공통 13개와 선택된 Java fragment·bridge 2개 path가 존재함 |
| Required skill path existence | Info | Passed | Profile skill 20개 path가 모두 존재함 |
| Required bridge resolved | Info | Passed | Java–Spring, Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API bridge가 선택되고 dependency가 충족됨 |
| Backend language selection | Info | Passed | `exactly-one` variant에서 Java 하나를 선택하고 Kotlin은 resolved 집합에서 제외함 |
| Alternative variant | Info | Passed | Kotlin + Kotlin–Spring은 별도 `ready` dry-run으로 유지되며 이번 preview에는 포함되지 않음 |
| Adapter template path existence | Info | Passed | Codex template path가 존재하고 `mvp-contract` 호환 상태임 |
| Output section completeness | Info | Passed | Java variant preview에 8개 필수 section과 source provenance가 있음 |
| Output size budget compliance | Info | Passed | Preview가 300 lines, 24 headings, 4,000 estimated tokens 목표 안이고 skill body inline이 없음 |
| Protected file untouched | Info | Passed | Root/global AGENTS, hook과 `.gitauto/`를 adapter output으로 쓰지 않음 |
| Unsupported feature warning | Info | Passed | 실제 export, skill 설치와 hook 병합을 profile output으로 요구하지 않아 warning 없음 |

## Variant 해소 근거

`backend_language`의 `required: true`, `selection: exactly-one` 조건에 따라 Java option을 dry-run 입력으로 선택했다. `language-java`와 `bridge-java-spring`을 함께 resolved 집합에 포함했고 Kotlin 묶음은 제외했다.

Kotlin option은 profile에서 삭제하거나 무효화하지 않았으며 `examples/codex/fullstack-spring-react/`에서 별도 검증됐다. 이번 Java preview에는 Kotlin 규칙과 bridge를 혼합하지 않는다.

## Output Size

측정 대상 Java variant `AGENTS.preview.md`는 103 lines, 15 headings, 5,256 characters와 약 1,752 estimated tokens다. `docs/output-size-budget.md` 및 profile의 300/24/4,000 목표 안에 있다. 실제 tokenizer 또는 validator 구현을 의미하지 않는다.

## Readiness

Java variant, required source, dependency, bridge, skill과 section이 모두 유효하고 error와 warning이 없다. 최종 상태는 `ready`다. `AGENTS.preview.md`는 dry-run preview example이며 실제 root `AGENTS.md` 또는 export 가능한 설정이 아니다.
