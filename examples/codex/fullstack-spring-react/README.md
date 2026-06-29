# Fullstack Spring React Codex Dry-run

> 이 디렉터리는 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이나 export 결과가 아니며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `fullstack-spring-react` profile의 Spring backend, React frontend, RDB와 REST API 계약 구성이 Codex project instruction preview로 해소 가능한지 검증한다. 공통 fragment·skill, 다중 bridge와 backend language variant를 함께 추적한다.

## Dry-run 대상

- Profile: `profiles/fullstack-spring-react/profile.yml`
- Profile ID: `fullstack-spring-react`
- Adapter: `adapters/codex/adapter.md`
- Template: `templates/codex/AGENTS.md.template`
- Preview 상태: `blocked`

## Fullstack 경계 검토

- Spring backend는 use case, transaction, persistence와 server-side API contract를 소유한다.
- React frontend는 component, UI state와 API client 경계를 소유한다.
- REST 계약은 request/response/error, 인증, pagination과 version 호환성을 양쪽에 연결한다.
- RDB entity/schema를 frontend 계약으로 직접 노출하지 않고 transport DTO와 UI model을 구분한다.
- Modular Monolith module 경계는 Spring bean, transaction과 table ownership에 연결한다.

## Java/Kotlin Variant 해석

Profile의 `backend_language`는 `exactly-one`, `required: true`다. Java를 선택하면 Java fragment와 Java–Spring bridge를, Kotlin을 선택하면 Kotlin fragment와 Kotlin–Spring bridge를 함께 적용해야 한다.

이번 dry-run에는 실제 project language 입력이 없으므로 어느 쪽도 기본 선택하지 않았다. 두 option의 source와 dependency는 모두 검증했지만 상태는 `selection-required`이며, Codex 계약상 완성 preview는 차단된다. `AGENTS.preview.md`는 공통 구조를 보여 주는 진단용 partial preview다.

## 산출물과 범위

`AGENTS.preview.md`, `merge-trace.md`, `skill-selection.md`, `validation-report.md`는 설계 검증 example이다. Generator, validator, CLI, file writer, skill 설치와 실제 export는 수행하지 않았다.
