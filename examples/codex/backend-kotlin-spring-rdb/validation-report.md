# Manual Validation Report

> Phase 8 validation report 계약을 적용한 `backend-kotlin-spring-rdb` + Codex dry-run 결과다. Validator 실행 결과가 아니라 source를 수동 대조한 example이다.

## Summary

| 항목 | 결과 |
| --- | --- |
| Profile | `backend-kotlin-spring-rdb` |
| Adapter | `codex` |
| Overall status | `passed-with-warnings` |
| Preview status | `ready-with-warnings` |
| Error | 0 |
| Warning | 1 |
| Info | 8 |
| File write | 수행하지 않음 |

## Check 결과

| Check | Severity | Status | 근거와 결과 |
| --- | --- | --- | --- |
| YAML parse | Info | Passed | Registry catalog 5개와 대상 profile manifest가 YAML로 parse됨 |
| Path existence | Info | Passed | Catalog 5개, profile, adapter, template, fragment 11개와 skill 15개 등 dry-run 필수 source가 존재함 |
| Duplicate ID | Info | Passed | Fragment 27, skill 24, profile 6, adapter 3, compatibility 10 entry가 각 catalog namespace에서 유일함 |
| Missing dependency | Info | Passed | 선택 fragment와 skill의 hard dependency가 모두 profile 집합에서 충족됨 |
| Unresolved optional item | Info | Passed | 대상 profile에는 variant와 pending item이 없고 optional 추가 선택도 없음 |
| Compatibility violation | Info | Passed | Kotlin–Spring, Spring–RDB와 Spring–Modular Monolith 관계가 모두 supported이며 incompatible 관계가 없음 |
| Missing bridge | Info | Passed | 세 compatibility 관계의 required bridge가 모두 profile에 선택됨 |
| Unsupported adapter output | Warning | Warning | Codex project preview template은 존재하지만 adapter가 draft이며 실제 file write·skill 설치·hook 병합은 지원하지 않음 |
| Output length warning | Info | Passed | Preview 110 lines, 16 headings, 약 1,540 estimated tokens로 300/24/4,000 목표 안이며 skill body inline이 없음 |

## YAML Parse

- `registry/fragments.yml`
- `registry/skills.yml`
- `registry/profiles.yml`
- `registry/adapters.yml`
- `registry/compatibility-matrix.yml`
- `profiles/backend-kotlin-spring-rdb/profile.yml`

모두 parsing 가능했다. 이 확인은 일회성 수동 검증이며 validator 구현을 추가하지 않았다.

## Path Existence

- Profile fragment reference: 11/11 존재
- Profile skill reference: 15/15 존재
- Codex adapter 문서: 존재
- Codex `AGENTS.md` template: 존재
- Catalog YAML: 5/5 존재

Pending path를 실제 source로 해석하지 않았다.

## Dependency 및 Bridge

- Fragment dependency: 모두 충족
- Skill hard dependency: 모두 충족
- Kotlin + Spring → `bridge-kotlin-spring`: 선택됨
- Spring + RDB → `bridge-spring-rdb`: 선택됨
- Spring + Modular Monolith → `bridge-spring-modular-monolith`: 선택됨

## Conflict

- Fragment `conflicts_with`: 선택 집합 내 충돌 없음
- Skill conflict: 없음
- Profile exclude: Java 및 Java–Spring bridge가 선택되지 않아 충족
- Semantic conflict: 확인된 blocking conflict 없음
- Deduplication: 일반 검증, REST 기본, transaction과 null/coroutine 영역에서 수동 축약 후보 확인

## Unsupported Feature

이번 dry-run은 다음 기능을 사용하지 않았다.

- 실제 root `AGENTS.md` 또는 전역 `~/.codex/AGENTS.md` 생성
- Skill directory 설치
- `.codex/hooks.json` 생성·병합
- Existing file diff, backup와 overwrite
- Commit, push와 외부 worklog publish

따라서 unsupported output은 preview를 차단하지 않지만 실제 적용 가능성을 의미하지 않는다.

## Preview Readiness 판정

Error가 없고 필수 path, dependency, compatibility bridge와 template이 확인됐으므로 압축된 Codex project preview example은 만들 수 있다.

다음 warning은 실제 적용 전에 해결하거나 명시적으로 수용해야 한다.

1. Codex adapter draft 및 file write/skill/hook output 미지원

Phase 9-1의 Spring–Modular Monolith pending과 비정량 output size budget warning은 해소됐다. Size 판정은 `docs/output-size-budget.md`의 수동 추정 기준을 사용했으며 실제 tokenizer 구현을 의미하지 않는다.

최종 판정은 `ready-with-warnings`다. `AGENTS.preview.md`는 review용 example이며 export 가능한 실제 설정이 아니다.
