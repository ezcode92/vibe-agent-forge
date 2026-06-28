# Web UI MVP Scope

## 목적

Web UI의 첫 검증 범위를 registry 조회와 profile 조합의 수동 의사결정에 한정한다. 실제 파일 생성·설치 없이 사용자가 catalog 관계를 이해하고 Codex 기준 preview outline까지 도달할 수 있는지를 검증한다.

## MVP 목표

- Registry 자산을 category와 관계로 찾을 수 있다.
- 기존 profile을 선택하거나 새 profile 초안을 조합할 수 있다.
- Required bridge, conflict와 pending을 구분할 수 있다.
- 선택 source와 adapter별 논리 preview를 검토할 수 있다.
- 추천이 자동 수정이 아니라 근거 있는 선택 보조로 동작한다.

## MVP 포함 범위

### Registry Browsing

- Fragment, skill, profile, adapter와 compatibility entry 목록·상세
- Category, status와 ID 기반 filter 개념
- Dependency, conflict, recommended profile과 source path 표시

### Profile Selection

- 6개 catalog profile 선택
- Manifest의 필수 fragment/skill, variant와 pending 표시
- 새 Builder 초안의 시작점으로 복사하는 개념

### Profile Builder

- Project type, language, framework/platform, database/API/architecture 선택
- Bridge와 skill 추천 및 사용자 확인
- Adapter target 선택
- Preview 전 checklist

### Compatibility Check

- Compatible, requires bridge, pending, incompatible와 unregistered 구분
- Fragment dependency/conflict와 variant 조건 확인
- Conflict 해결 추천과 사용자 결정 기록

### Preview

- Codex `AGENTS.md` template 기준 source summary와 logical outline
- Selected fragment/skill, merge order, warning과 validation checklist
- Claude/Gemini는 adapter/template metadata를 표시하되 의미 동등성 검증 전 draft 상태 유지

## MVP 제외 범위

- 실제 repository 및 agent 파일 write
- Generator, merge engine과 자동 validator
- Installer, backup, archive와 download
- Background sync와 catalog 자동 refresh
- User account, 인증·권한과 개인 workspace
- Remote repository 연결과 Git operation
- 실제 frontend/backend application 및 Web UI component code
- API endpoint, database schema와 mock server
- Recommendation 학습, 최적 profile 자동 생성과 conflict 자동 수정

## Codex 우선 검증

1. Codex adapter를 기본 preview target으로 표시한다.
2. `templates/codex/AGENTS.md.template`의 section과 profile source mapping을 검토한다.
3. Global/project scope, skill 분리와 git-auto warning이 UI 모델에 표현되는지 확인한다.
4. 실제 merge content와 file write 없이도 사용자가 선택 근거와 미지원 범위를 이해하는지 검증한다.
5. 기준이 안정된 뒤 Claude/Gemini의 차이를 독립 adapter 계약으로 확장한다.

Codex 우선은 특정 frontend/backend stack 선택을 의미하지 않는다.

## MVP 성공 기준

- 사용자가 기존 profile에서 selected source와 pending을 추적할 수 있다.
- 새 profile 흐름에서 필수 bridge와 conflict를 놓치지 않는다.
- Preview가 실제 생성 결과로 오해되지 않고 source·warning을 함께 보여 준다.
- Catalog에 없는 관계를 supported로 추정하지 않는다.
- File write와 자동 수정 action이 제공되지 않는다.

## 후속 단계 진입 조건

- 화면·entity 용어와 catalog mapping이 수동 검토에서 일관된다.
- Compatibility와 conflict 상태의 의미가 profile 작성자에게 명확하다.
- Codex preview outline과 adapter 미지원 진단 기준이 합의된다.
- Generator, validator 또는 repository binding 구현을 별도 승인할 준비가 된다.

## 현재 범위

이 문서는 MVP 설계 범위만 고정한다. 기술 stack, UI 구현, API, DB, 배포와 운영 방식은 결정하지 않는다.
