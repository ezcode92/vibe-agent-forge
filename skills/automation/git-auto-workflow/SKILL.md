---
name: git-auto-workflow
description: Git-auto Codex hook 저장소에서 변경 검증, 자동 commit·GitHub push·Notion worklog 흐름과 실패 후 pending 재처리를 안전하게 운영한다. 저장소가 git-auto hook을 작업 종료 자동화로 선언했을 때 사용한다.
---

# Git-auto Workflow

## 목적

직접 Git publish를 수행하지 않고 git-auto Stop hook이 변경과 worklog를 처리하도록 준비하며, 자동화 실패 시 원인을 확인한 뒤 pending 기록을 안전하게 재처리한다. Hook 로직 자체를 변경하는 절차는 포함하지 않는다.

## 사용 조건

- 저장소 지침이 git-auto hook 사용을 명시할 때만 적용한다.
- 직접 commit·push 금지와 `.gitauto/` 제외 정책을 우선한다.
- 외부 publisher 재처리는 사용자 요청 또는 저장소가 허용한 복구 범위 안에서만 수행한다.

## 입력 Context

- 사용자 요청과 저장소 git-auto 지침
- Git status, 변경 파일과 검증 결과
- Hook 실행 결과, doctor 진단과 secret을 제거한 오류
- `.gitauto/pending/`의 파일 존재 여부와 publisher 상태

## 작업 절차

1. 작업 전 Git status와 hook 설정의 존재를 확인하되 `.codex/hooks`를 수정하지 않는다.
2. 파일 변경과 검증까지만 수행하고 직접 commit, push 또는 일반 publish를 실행하지 않는다.
3. 종료 전 변경 요약, 검증 결과, 실패와 남은 이슈를 worklog에 적합하게 정리한다.
4. `.gitauto/`가 ignore되고 staged·tracked 대상에 포함되지 않았는지 확인한다.
5. Stop hook 결과에서 commit, push와 publisher 성공·실패를 각각 구분한다.
6. Publisher 실패 시 pending 파일을 보존하고 `git-auto doctor`로 환경·schema·연결 상태를 secret 출력 없이 확인한다.
7. Schema 변경이 필요하면 dry-run 결과가 additive하고 예상 범위인지 검토한 뒤 명시적으로 허용된 경우에만 migration을 적용한다.
8. 원인이 해결된 뒤 pending publish를 재실행하고 성공한 파일이 pending에서 제거되었는지 확인한다.

## 검증 기준

- 작업 중 직접 commit·push를 수행하지 않는다.
- `.gitauto/` 파일이 수정·staging·commit 대상에 포함되지 않는다.
- Worklog가 요청 요약, 변경 파일, 검증과 남은 이슈를 사실대로 담는다.
- GitHub push와 Notion publish 결과를 하나의 성공으로 뭉뚱그리지 않는다.
- Pending 재처리는 실패 원인 해결 후 수행하고 처리 여부를 확인한다.

## 금지 패턴

- Hook을 기다리지 않고 직접 commit, push 또는 중복 publish하지 않는다.
- Pending 파일을 수동 삭제하거나 내용을 변경해 실패를 숨기지 않는다.
- Token, database ID, credential과 민감한 오류 context를 출력하지 않는다.
- Doctor 또는 migration dry-run 확인 없이 schema를 변경하지 않는다.
- Git 성공을 근거로 외부 worklog 업로드도 성공했다고 가정하지 않는다.

## 완료 기준

- 정상 흐름에서는 hook이 처리할 clean한 변경·검증 요약이 준비된다.
- 실패 복구에서는 원인, 조치와 재처리 결과가 구분된다.
- 성공한 pending 기록이 제거되고 실패한 기록은 보존된다.
- 직접 commit·push 없이 최종 Git 및 ignore 상태가 확인된다.

## 참고 문서

- `skills/common/commit-worklog/SKILL.md`
- `core/global/agents.fragment.md`
- 저장소 `AGENTS.md`의 git-auto hook 지침
