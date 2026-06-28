---
name: flutter-build-debug
description: Flutter build 실패를 flavor, platform target, dependency, generated file과 Android/iOS 고유 경계로 분리해 재현·진단한다. Flutter build, package 해석 또는 platform별 compile 문제가 발생했을 때 사용한다.
---

# Flutter Build Debug

## 목적

Flutter build 실패를 재현 가능한 configuration과 platform 경계로 좁히고 원인을 최소 수정으로 해결한다. Build script 생성, signing credential 변경과 무관한 dependency upgrade는 수행하지 않는다.

## 사용 조건

- Flutter build 또는 platform compile·package 단계가 실패할 때 적용한다.
- 대상 flavor, mode, platform과 환경 version을 명시한다.
- 진단만 요청된 경우 수정하지 않고 원인과 검증 방법만 제시한다.

## 입력 Context

- 실패한 build 명령, flavor, mode와 platform target
- 전체 오류의 최초 원인과 관련 log
- Dependency manifest·lock, SDK/toolchain과 환경 차이
- Generated file, source file, build output과 ignore 정책

## 작업 절차

1. 동일한 flavor, mode, target과 환경에서 실패를 재현한다.
2. Wrapper 오류보다 먼저 발생한 compile, dependency, configuration 또는 signing 원인을 찾는다.
3. 모든 platform 공통 문제인지 Android 또는 iOS 전용 문제인지 최소 target으로 분리한다.
4. Dependency constraint, lock 상태, transitive 충돌과 지원 SDK 범위를 확인한다.
5. Generated file이 source-of-truth인지 재생성 산출물인지 확인하고 build output과 구분한다.
6. Flavor별 entry, resource, identifier와 environment 설정 차이를 비교한다.
7. 확인된 원인만 최소 수정하고 동일 target에서 재검증한 뒤 필요한 다른 target으로 확대한다.

## 검증 기준

- 실패가 특정 flavor, mode, platform과 환경에서 재현된다.
- 최초 원인과 후속 오류가 구분된다.
- Dependency 해결 결과와 지원 SDK/toolchain 범위가 일치한다.
- Generated source와 삭제 가능한 build output이 명확히 구분된다.
- 수정 후 원래 target과 영향받는 다른 target의 build 결과가 기록된다.

## 금지 패턴

- 오류 원인을 모른 채 cache, lock과 generated file을 무조건 삭제하지 않는다.
- Generated file을 직접 편집해 재생성 시 사라질 수정을 만들지 않는다.
- 한 platform 문제를 공통 Flutter code 문제로 단정하지 않는다.
- 진단을 위해 signing secret과 credential을 출력·commit하지 않는다.
- 실제 build script나 platform project를 요청 범위 밖에서 새로 만들지 않는다.

## 완료 기준

- 실패 원인이 공통, flavor, dependency 또는 platform 경계로 분류된다.
- 허용된 경우 최소 수정 후 대상 build가 통과한다.
- Generated/build output 처리와 다른 target 영향이 확인된다.
- 미검증 platform, 환경 차이와 credential 의존성이 보고된다.

## 참고 문서

- `skills/common/debugging/SKILL.md`
- `stacks/mobile/flutter/agents.fragment.md`
- 프로젝트의 Flutter build 및 platform 설정 문서
