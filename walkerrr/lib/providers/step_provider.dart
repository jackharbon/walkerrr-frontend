int globalSteps = 0;

class StepsContext {
  updateGlobalSteps(newGlobalSteps) {
    globalSteps = newGlobalSteps;
    // print('---- StepContext on step_provider:\n$globalSteps');
  }
}
