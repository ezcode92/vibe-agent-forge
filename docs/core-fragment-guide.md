# Core Fragment 가이드

## 목적

Core fragment는 특정 기술 스택이나 대상 AI 에이전트에 종속되지 않는 공통 지침의 원본이다. 모든 조합에서 반복되는 작업 방식과 품질 판단 기준을 한곳에서 관리하고, 저장소별 정보와 기술별 관례가 들어갈 위치를 분리하는 것이 목적이다.

Core fragment는 최종 `AGENTS.md` 자체도, 실제 프로젝트 설정도 아니다. Profile이 선택한 구성 요소를 merge 정책에 따라 조합할 때 사용하는 중립 source이며 대상 에이전트의 파일 형식은 adapter가 담당한다.

## Fragment별 책임

| 구분 | 책임 | 포함하지 않는 내용 |
| --- | --- | --- |
| `core/global/agents.fragment.md` | 응답, context, 사전 분석, 최소 변경, 검증, 보안과 공통 Git 작업 원칙 | 저장소 목표, 실제 명령, 기술 관례와 architecture |
| `core/project/agents.fragment.md` | 프로젝트 `AGENTS.md`가 채워야 할 목표, 요구사항, 경로, 명령, 경계와 완료 기준의 구조 | 확인되지 않은 실제 값, 기술별 구현 규칙과 조건부 작업 절차 |
| `core/quality/agents.fragment.md` | 확장성, 유지보수성, 테스트 가능성과 설계 선택을 평가하는 기술 중립 규칙 | 특정 class 구조, framework 기능, library 또는 도구 강제 |

Global은 프로젝트가 바뀌어도 유지되는 작업 정책이다. Project는 저장소마다 달라지는 사실과 제약을 넣는 자리다. Quality는 구현 또는 설계 대안을 비교할 때 적용하는 판단 기준이다. 같은 규칙을 여러 core fragment에 복제하지 않는다.

## Stack 및 Bridge Fragment와의 관계

Stack fragment는 하나의 language, framework, platform, database, architecture 또는 API를 선택했을 때 달라지는 관례와 검증을 추가한다. Core fragment의 일반 원칙을 반복하지 않고 해당 기술에서 구체화되는 차이만 제공한다.

Bridge fragment는 둘 이상의 stack이 동시에 선택될 때만 필요한 interface, lifecycle과 계약 조정 규칙을 제공한다. 기술 조합에만 유효한 규칙은 core나 한쪽 stack fragment에 넣지 않는다.

Stack 또는 bridge 규칙이 core 원칙보다 구체적이더라도 상위 사용자·프로젝트 지침의 허용 범위를 넓힐 수 없다. 충돌과 중복은 `docs/merge-policy.md`의 우선순위와 진단 기준을 따른다.

## 최종 `AGENTS.md`에서의 위치

Global fragment는 전역 `AGENTS.md`의 기본 작업 원칙을 구성하며 프로젝트 결과에 그대로 복제하지 않는 것을 기본으로 한다. 대상 환경이 전역 지침을 별도로 지원하지 않아 프로젝트 결과에 포함해야 한다면 adapter가 중복과 의미 손실을 진단한다.

프로젝트용 최종 `AGENTS.md`의 논리적 구성 순서는 다음과 같다.

1. Project fragment를 실제 저장소 정보로 채운 프로젝트 목적과 적용 범위
2. 공통 quality와 기본 작업 원칙 중 프로젝트 문서에 필요한 항목
3. Profile이 선택한 독립 stack fragment
4. 선택 조합에 필요한 bridge fragment
5. 프로젝트 고유 제약, override와 실제 검증 명령

이 순서는 단순한 파일 이어 붙이기 순서가 아니다. 병합기는 규칙의 의미 영역, 구체성, 중복과 충돌을 검증해야 하며 project 지침과 사용자 현재 요청이 최종 권한을 가진다. 긴 배경 설명은 `docs/`에, 조건부 전문 절차는 skill에 남겨 최종 문서의 context를 제한한다.

## 기술 중립성 원칙

- Core fragment에는 특정 언어 문법, framework lifecycle, package 구조, build tool과 library 사용법을 넣지 않는다.
- 특정 기술을 예시로 들어야만 이해되는 규칙은 stack fragment 또는 별도 설계 문서로 이동한다.
- 둘 이상의 기술을 전제로 하는 API mapping, 데이터 변환과 배포 조정은 bridge fragment로 분리한다.
- RESTful API처럼 여러 stack에 공통인 품질 기준은 core에 둘 수 있지만 특정 server 또는 client 구현 방식은 포함하지 않는다.
- 새로운 core 규칙은 모든 지원 stack에서 의미가 유지되고 대상 agent와 무관하게 검증 가능한지 확인한다.

## 현재 범위

현재 문서는 core fragment의 초안과 조합 책임만 정의한다. 실제 기술별 fragment, bridge, skill, profile YAML, registry catalog, generator, installer, adapter 구현과 Web UI는 만들지 않는다.
