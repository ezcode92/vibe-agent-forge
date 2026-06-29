# Frontend React Codex Dry-run

> 이 디렉터리는 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이나 export 결과가 아니며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `frontend-react` profile의 JavaScript, React, RESTful API client 구성이 Codex preview로 조합 가능한지 검증한다. JavaScript–React bridge, frontend skill routing과 backend 미지정 상태의 API client 경계를 확인한다.

## Dry-run 대상

- Profile: `profiles/frontend-react/profile.yml`
- Adapter: `adapters/codex/adapter.md`
- Template: `templates/codex/AGENTS.md.template`
- Preview 상태: `ready`

## 검토 포인트

- JavaScript object·async 규칙과 React props·state·effect lifecycle의 연결
- REST resource/error/version 계약과 frontend API client 책임의 분리
- 특정 backend framework와 backend별 bridge를 선택하지 않는 경계
- 실제 React build tool, package manager와 state library를 추정하지 않는 placeholder 정책

## 산출물과 범위

`AGENTS.preview.md`, `merge-trace.md`, `skill-selection.md`, `validation-report.md`는 모두 설계 검증 example이다. Generator, validator, CLI, file writer, skill 설치와 실제 export는 수행하지 않았다.
