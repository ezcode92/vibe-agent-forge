# Web UI Information Architecture

## 목적

Web UI의 주요 화면, 화면별 책임과 registry catalog 소비 관계를 정의한다. Navigation과 데이터 흐름만 설명하며 route, component와 backend endpoint는 설계하지 않는다.

## 상위 Navigation

| 영역 | 포함 화면 | 역할 |
| --- | --- | --- |
| 탐색 | Dashboard, Registry Browser | 현재 자산과 시작점 파악 |
| 구성 | Profile Builder, Compatibility Checker, Conflict Resolver | Profile 선택·조합과 진단 |
| 결과 | Preview, Export Plan | 읽기 전용 결과와 향후 작업 계획 검토 |
| 연결 | Project Binding | 기존 repository 연결 계획 검토 |
| 관리 | Settings | 사용자 표시·검토 기본값 관리 개념 |

## 화면별 정의

### Dashboard

- 목적: Catalog 현황, draft/pending 관계, 최근 수동 작업 초안과 빠른 시작점을 요약한다.
- 주요 행동: 기존 profile 열기, 새 Builder 시작, pending compatibility 보기.
- 사용 catalog: `profiles.yml`, `fragments.yml`, `skills.yml`, `adapters.yml`, `compatibility-matrix.yml`.
- 제외: 실제 실행 이력, 원격 sync와 계정별 활동 집계.

### Registry Browser

- 목적: Fragment, skill, profile과 adapter를 category·status·ID로 탐색하고 관계를 확인한다.
- 주요 행동: 항목 상세 보기, dependency/conflict 이동, Builder 선택 후보에 추가.
- 사용 catalog: 모든 registry catalog.
- 제외: Catalog YAML 편집과 source 파일 수정.

### Profile Builder

- 목적: Project type을 기준으로 fragment, bridge, skill과 adapter target을 선택한다.
- 주요 행동: 기존 profile 불러오기, 새 조합 구성, 추천 수락·거절, 검토 상태 저장 개념.
- 사용 catalog: `profiles.yml`, `fragments.yml`, `skills.yml`, `adapters.yml`.
- 추가 입력: 선택한 profile manifest의 variant, pending과 output constraint.

### Compatibility Checker

- 목적: 현재 stack 조합의 compatible, requires bridge, pending과 conflict 후보를 보여 준다.
- 주요 행동: 관계 근거 보기, 필수 bridge 추천, 미등록 관계 표시.
- 사용 catalog: `compatibility-matrix.yml`, `fragments.yml`.
- 제외: 자동 bridge 삽입과 자동 수정.

### Conflict Resolver

- 목적: Dependency 누락, `conflicts_with`, variant 중복, pending과 adapter 미지원 항목을 한곳에서 검토한다.
- 주요 행동: Fragment 제거 제안, bridge 추가 제안, profile 변경, pending 보류.
- 사용 catalog: 모든 registry catalog와 선택한 profile manifest.
- 제외: 사용자 승인 없는 선택 변경.

### Preview

- 목적: Adapter별 논리 출력 구조, selected source, merge order, warning과 검증 checklist를 읽기 전용으로 보여 준다.
- 주요 행동: Agent tab 전환, source 추적, warning에서 Resolver로 이동.
- 사용 catalog: `adapters.yml`, `fragments.yml`, `skills.yml`과 resolved profile.
- 제외: 실제 파일 생성과 완성된 merge 결과 보장.

### Export Plan

- 목적: 향후 생성될 파일 후보, overwrite 위험, backup·review 단계와 미지원 출력을 계획으로 정리한다.
- 주요 행동: 출력 대상 검토, Project Binding 이동, 수동 작업 목록 확인.
- 사용 catalog: `adapters.yml`, `profiles.yml`과 PreviewResult.
- 제외: Download, file write, installer와 Git 변경.

### Project Binding

- 목적: Profile 초안을 기존 repository metadata와 연결하고 충돌 파일 및 운영 정책을 검토한다.
- 주요 행동: Project metadata 입력, 기존 agent 파일 상태 기록, backup/preview 계획 확인.
- 사용 catalog: `profiles.yml`, `adapters.yml` 및 선택 항목에 필요한 fragment/skill catalog.
- 제외: Repository scan, 파일 읽기·쓰기와 Git 실행.

### Settings

- 목적: 기본 adapter, 표시 언어, warning strictness와 수동 검토 preference를 표현하는 개념적 화면이다.
- 주요 행동: Session 또는 사용자 preference 후보 관리.
- 사용 catalog: `adapters.yml`과 catalog version metadata.
- 제외: Credential, 실제 user account, server settings와 agent 설치.

## 화면 간 이동 흐름

### 신규 Profile 흐름

Dashboard → Profile Builder → Compatibility Checker → Conflict Resolver → Preview → Export Plan → Project Binding

Conflict가 없으면 Resolver를 건너뛸 수 있지만 Compatibility 결과와 preview 전 checklist는 생략하지 않는다.

### 기존 Profile 검토 흐름

Registry Browser 또는 Dashboard → Profile Builder → Compatibility Checker → Preview

Profile manifest에 pending 또는 variant가 있으면 Preview 전에 Conflict Resolver에서 사용자 결정을 요구한다.

### 문제 역추적 흐름

Preview warning → Conflict Resolver → Registry Browser 상세 → Profile Builder 선택 변경 → Compatibility Checker → Preview 재검토

## 공통 화면 상태

- Loading: Catalog 조회 중이라는 가정만 표시하며 background fetch 구현은 정의하지 않는다.
- Empty: Catalog에 항목이 없거나 filter 결과가 없음을 구분한다.
- Error: YAML parsing, 참조 누락과 지원하지 않는 relation을 구분한다.
- Pending: 기능 실패가 아니라 아직 설계·bridge가 없는 상태로 표시한다.
- Stale: Catalog version이 변경됐다는 개념적 경고이며 자동 refresh는 구현하지 않는다.

## 현재 범위

IA는 정보와 이동 관계만 정의한다. URL, route, component hierarchy, API endpoint, state library와 persistence 방식은 후속 구현 단계의 결정이다.
