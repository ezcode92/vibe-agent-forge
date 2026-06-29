# Manual Validation Report

> `flutter-app` + Codex dry-run에 adapter validation 계약을 수동 적용한 example이다. Validator 실행 결과가 아니다.

## Summary

| 항목 | 결과 |
| --- | --- |
| Profile | `flutter-app` |
| Adapter | `codex` (`mvp-contract`) |
| Overall status | `passed` |
| Preview status | `ready` |
| Error | 0 |
| Warning | 0 |
| File write | 수행하지 않음 |

## Check 결과

| Check | Severity | Status | 근거와 결과 |
| --- | --- | --- | --- |
| Profile/catalog parse | Info | Passed | 대상 manifest와 registry catalog 구조를 수동 대조함 |
| Path existence | Info | Passed | Fragment 8개, skill 11개, adapter와 template path가 모두 존재함 |
| Dependency | Info | Passed | Fragment와 skill hard dependency가 선택 집합에서 충족됨 |
| Dart–Flutter bridge | Info | Passed | Compatibility가 요구한 `bridge-dart-flutter`가 선택됨 |
| Flutter–REST API bridge | Info | Passed | Compatibility가 요구한 `bridge-flutter-rest-api`가 선택됨 |
| Product boundary | Info | Passed | State library, build flavor, HTTP client와 backend를 추정하지 않음 |
| Template/section | Info | Passed | Template의 8개 section과 preview 안내를 유지함 |
| Placeholder policy | Info | Passed | 실제 project metadata와 validation command를 placeholder로 유지함 |
| Skill body inline | Info | Passed | Skill 본문 없이 ID·역할·trigger만 요약함 |
| Unsupported output | Info | Passed | 실제 file write, hook 병합과 skill 설치를 요구하지 않음 |
| Output size | Info | Passed | 공통 수동 budget의 300 lines, 24 headings, 4,000 estimated tokens 이하 |

## Output Size

측정 대상 `AGENTS.preview.md`는 92 lines, 14 headings, 3,689 characters와 약 1,230 estimated tokens다. `docs/output-size-budget.md`의 300/24/4,000 공통 목표 안에 있다. Profile의 비정량 size 문구는 이 수동 측정으로 보완했으며 실제 tokenizer 구현을 의미하지 않는다.

## Readiness

Required source, dependency와 두 bridge가 확인됐고 error와 warning이 없다. 최종 상태는 `ready`다. 이 preview는 review용 example이며 실제 root `AGENTS.md` 또는 export 가능한 설정이 아니다.
