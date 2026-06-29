# Fullstack Spring React Java Codex Dry-run

> 이 디렉터리는 Java backend variant의 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이나 export 결과가 아니며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `fullstack-spring-react` profile을 Java backend variant로 해석했을 때 Spring backend, React frontend, RDB와 REST API 계약이 Codex project instruction preview로 조합 가능한지 검증한다.

## Dry-run 대상

- Profile: `profiles/fullstack-spring-react/profile.yml`
- Profile ID: `fullstack-spring-react`
- Adapter: `adapters/codex/adapter.md`
- Template: `templates/codex/AGENTS.md.template`
- Backend language variant: `java`
- Preview 상태: `ready`

## Variant 관계

이번 dry-run은 `language-java`와 `bridge-java-spring`을 하나의 variant 묶음으로 적용한다. Kotlin fragment와 Kotlin–Spring bridge는 포함하지 않는다.

Kotlin backend variant는 `examples/codex/fullstack-spring-react/`에서 별도 `ready` dry-run으로 검증됐다. 두 결과는 같은 profile의 대체 선택이며 하나의 preview에 동시에 병합하지 않는다.

## Fullstack 경계 검토

- Spring backend는 use case, transaction, persistence와 server-side API contract를 소유한다.
- React frontend는 component, UI state와 API client 경계를 소유한다.
- REST 계약은 request/response/error, 인증, pagination과 version 호환성을 양쪽에 연결한다.
- RDB entity/schema를 frontend 계약으로 직접 노출하지 않고 transport DTO와 UI model을 구분한다.
- Modular Monolith module 경계는 Spring bean, transaction과 table ownership에 연결한다.

## 산출물과 범위

`AGENTS.preview.md`, `merge-trace.md`, `skill-selection.md`, `validation-report.md`는 설계 검증 example이다. Generator, validator, CLI, file writer, skill 설치와 실제 export는 수행하지 않았다.
