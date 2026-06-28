# Project Binding Flow

## 목적

선택한 profile 초안을 기존 repository의 metadata와 연결하고 agent 출력 충돌, overwrite 위험과 운영 정책을 실제 파일 변경 전에 검토하는 흐름을 정의한다. Repository 접근과 쓰기는 수행하지 않는다.

## Project Metadata 입력

| 항목 | 의미 | 검토 기준 |
| --- | --- | --- |
| Project name | Preview와 binding을 구분할 표시 이름 | 비어 있지 않고 repository 목적과 일치 |
| Repository path | 사용자가 지정한 local repository 위치 개념 | 실제 접근·검증은 구현 범위 밖 |
| Primary language | Profile language 또는 선택 variant | Profile stack과 일치 |
| Framework/platform | 선택된 실행환경 | 필요한 language bridge 존재 |
| Architecture | 배포 형태 및 내부 style | Conflict와 pending 확인 |
| Adapter target | Codex, Claude 또는 Gemini | Adapter status와 미지원 출력 확인 |

Metadata는 project `AGENTS.md`를 대체하지 않으며 secret, credential와 사용자 로컬 설정을 입력 대상으로 삼지 않는다.

## Binding 흐름

1. Profile Builder에서 resolved 또는 pending-accepted profile을 전달받는다.
2. 사용자가 project metadata를 입력한다.
3. Profile stack과 metadata의 language, framework/platform 및 architecture 일치를 비교한다.
4. Adapter target에 따른 예상 파일 이름과 scope를 표시한다.
5. 기존 agent 파일의 존재 여부를 사용자가 `없음 / 있음 / 알 수 없음`으로 기록한다.
6. 충돌 가능성이 있으면 overwrite 대신 preview, backup과 review 계획을 요구한다.
7. Validation checklist와 Git 운영 정책을 확인한다.
8. Export Plan으로 이동해 수동 후속 작업만 정리한다.

## 기존 Agent 파일 처리 정책

### `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`가 없는 경우

- 신규 생성 후보로 표시하지만 실제 파일을 만들지 않는다.
- Project metadata와 미치환 placeholder를 먼저 확인한다.

### 대상 파일이 있는 경우

- Overwrite를 기본 동작으로 제공하지 않는다.
- 기존 파일이 사용자 작성, 다른 generator 또는 AgentForge 산출물인지 알 수 없다고 가정한다.
- 기존 content 보존, 새 preview와의 차이 검토, backup 계획과 수동 승인 단계를 요구한다.
- Merge 근거가 없으면 자동 결합하지 않고 conflict로 표시한다.

### 존재 여부를 알 수 없는 경우

- Export readiness를 제한하고 repository 확인이 필요하다고 표시한다.
- 없음으로 추정해 신규 파일 계획을 만들지 않는다.

## Overwrite 금지 원칙

- 사용자의 기존 agent 지침, settings와 hook을 자동 대체하지 않는다.
- File path가 같다는 이유로 source ownership이 같다고 가정하지 않는다.
- Adapter 간 출력 파일을 서로 변환·덮어쓰기 대상으로 취급하지 않는다.
- Backup과 review 없이 destructive 작업을 추천하지 않는다.

## Backup, Preview, Review 순서

1. 기존 파일 존재와 ownership 확인
2. Backup 필요성과 보관 위치를 사용자가 결정
3. Source summary 및 logical preview 확인
4. Existing-vs-proposed diff가 필요하다는 계획 기록
5. Conflict, unsupported와 secret 노출 검토
6. 사용자의 명시적 승인 후에만 향후 별도 구현이 write를 수행

현재 Web UI는 backup 파일, diff와 write를 실제로 만들지 않는다.

## Git-auto Repository 안내

- Repository가 git-auto Codex Stop hook을 사용하면 직접 commit·push하지 않도록 명확히 표시한다.
- `.gitauto/`는 binding, backup, export와 staging 대상에서 제외한다.
- 기존 `.codex/hooks`와 `.codex/hooks.json`을 자동 수정하지 않는다.
- File 변경과 검증 이후 작업 기록은 repository hook 정책에 맡긴다는 review 항목을 제공한다.
- Hook 또는 publisher 실패를 UI가 자동 재처리하지 않는다.

## 완료 상태

- Metadata가 profile과 일치한다.
- Adapter target 및 예상 output scope가 확인됐다.
- 기존 파일 상태와 overwrite 위험이 기록됐다.
- Backup/preview/review 계획과 Git 운영 정책이 확인됐다.
- 실제 write가 수행되지 않았음이 명시됐다.

## 현재 범위

Repository scan, filesystem permission, backup, diff, file write, Git과 remote 연결은 구현하지 않는다. Project Binding은 사용자가 입력한 metadata를 바탕으로 위험과 후속 계획을 문서화하는 흐름이다.
