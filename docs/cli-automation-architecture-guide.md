# CLI Automation Architecture 가이드

## 목적

`stacks/architecture/cli-automation/agents.fragment.md`가 담당하는 책임과 profile 선택 기준을 설명한다. 이 문서는 CLI나 automation 구현 방법이 아니라 fragment 조합을 위한 설계 가이드다.

## Architecture Fragment가 필요한 이유

CLI와 automation은 짧은 command entrypoint로 시작하기 쉽지만 입력 해석, 핵심 판단, filesystem·network·process 변경과 사용자 출력이 한곳에 결합되면 실패와 재실행 의미를 검증하기 어렵다. 특히 batch의 부분 성공, workflow 중단·재개와 retry는 언어 관례만으로 결정되지 않는다.

CLI automation architecture fragment는 다음 책임을 profile 수준에서 지속적으로 보존한다.

- Command entrypoint와 domain/service 판단의 분리
- Configuration, input과 output의 외부 경계
- Filesystem, network와 process side effect의 소유권
- One-shot, batch와 workflow별 성공·실패·재실행 의미
- Logging, user-facing output와 machine-readable 결과의 구분
- 핵심 판단의 독립 test 가능성과 작은 CLI의 구조 비용 제한

## Python Language Fragment만으로 부족한 지점

`stacks/language/python/agents.fragment.md`는 typing, exception, `pathlib.Path`, resource 관리와 test 가능한 언어 사용 원칙을 정의한다. 그러나 다음 architecture 결정은 Python에 한정되지 않는다.

- Command handler가 맡을 조정 책임과 domain/service 경계
- 여러 side effect를 어떤 실행 단위로 묶고 실패를 어떻게 관찰할지
- Batch 부분 성공과 workflow 재개 상태를 어떻게 해석할지
- Retry가 안전한 작업과 중복 변경을 만드는 작업의 구분
- Log, 사용자 message, structured output와 exit status의 계약

따라서 Python fragment에 이 규칙을 누적하지 않고 언어 중립적인 architecture fragment로 분리한다. Python과 CLI automation architecture 사이에 별도 lifecycle 변환 규칙이 없으므로 현재 bridge는 요구하지 않는다.

## Profile 포함 기준

다음 중 하나 이상이 주 실행 모델이면 이 fragment를 포함한다.

- 사용자가 실행하는 CLI command가 핵심 기능의 진입점이다.
- Filesystem, network 또는 외부 process를 변경하는 automation을 수행한다.
- 여러 대상을 처리하며 부분 실패와 재처리가 가능한 batch가 있다.
- 여러 단계의 선행 조건과 산출물을 가진 workflow를 실행한다.
- 동일 작업의 재실행, idempotency 또는 retry 정책이 중요하다.

단순 library, web application의 보조 command나 제품 고유 build script처럼 기존 project architecture가 책임을 충분히 소유하면 자동으로 추가하지 않는다. 두 architecture fragment가 함께 선택될 때는 command 경계와 전체 application 경계의 중복을 수동 검토한다.

## 다른 Architecture와의 차이

- Backend/web architecture는 request lifecycle, 장기 실행 service와 server-side contract가 중심이다.
- Mobile architecture는 UI lifecycle, navigation, device/platform 상태가 중심이다.
- Monolith/MSA는 배포 단위와 service 경계를 정의한다.
- Clean/Hexagonal architecture는 내부 policy와 외부 adapter 사이의 dependency direction을 더 일반적으로 정의한다.
- CLI automation architecture는 실행 시작·종료가 분명한 command, batch와 workflow의 side effect·재실행 계약에 집중한다.

이 fragment는 다른 architecture pattern의 축소판이 아니며, 작은 CLI에 여러 layer나 port를 의무화하지 않는다.

## Python CLI Dry-run Warning과의 관계

기존 `python-cli-automation` profile은 architecture fragment가 없어 command/module 책임 경계를 확정할 수 없다는 warning을 유지했다. 새 fragment를 profile과 registry에 등록하면 해당 pending은 해소된다.

이는 실제 project의 CLI framework, package manager, scheduler, command 목록과 validation command가 확정됐다는 의미가 아니다. Dry-run preview는 해당 값의 placeholder를 유지하며 실제 설정 export도 수행하지 않는다.

## 현재 범위

이 가이드는 fragment 책임과 선택 기준만 정의한다. 실제 Python/CLI 코드, generator, validator, framework adapter와 실행 도구를 구현하지 않는다.
