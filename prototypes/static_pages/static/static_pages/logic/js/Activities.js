// Generated by CoffeeScript 1.3.3
(function() {

  Breeze.Activities = (function() {
    var activitiesInitialized, activityList, availableActivities, chunckTimeLarge, chunckTimeMedium, chunckTimeSmall, currentActivity, currentActivityTimerRunning, currentPlaylist, currentPlaylistTimerRunning, nextActivity, userActionLog, userAvailablePlaylists, userChuncksCompletedDay, userChuncksCompletedMonth, userName;

    userName = 'Some Nameor';

    userAvailablePlaylists = ['default'];

    userChuncksCompletedMonth = 32;

    userChuncksCompletedDay = 0;

    userActionLog = [];

    activityList = [
      {
        id: 'an_id_001',
        text: 'Task Item One',
        duration: 'large'
      }, {
        id: 'an_id_002',
        text: 'Task Item Two',
        duration: 'custom'
      }, {
        id: 'an_id_003',
        text: 'Task Item Three',
        duration: 'medium'
      }, {
        id: 'an_id_004',
        text: 'Task Item Four',
        duration: 'small'
      }, {
        id: 'an_id_005',
        text: 'Task Item Five',
        duration: 'small'
      }, {
        id: 'an_id_006',
        text: 'Task Item Six',
        duration: 'large'
      }
    ];

    activitiesInitialized = false;

    availableActivities = [];

    currentPlaylist = '';

    currentActivity = '';

    nextActivity = '';

    currentPlaylistTimerRunning = false;

    currentActivityTimerRunning = false;

    chunckTimeSmall = 5;

    chunckTimeMedium = 25;

    chunckTimeLarge = 50;

    function Activities(attributes) {
      this.attributes = attributes;
      activitiesInitialized = true;
      availableActivities = activityList;
      return true;
    }

    Activities.statusReport = function() {
      var reportData;
      reportData = {
        activitiesInitialized: activitiesInitialized,
        availableActivities: availableActivities,
        currentPlaylist: currentPlaylist,
        currentActivity: currentActivity,
        nextActivity: nextActivity,
        currentPlaylistTimerRunning: currentPlaylistTimerRunning,
        currentActivityTimerRunning: currentActivityTimerRunning,
        chunckTimeSmall: chunckTimeSmall,
        chunckTimeMedium: chunckTimeMedium,
        chunckTimeLarge: chunckTimeSmall
      };
      return reportData;
    };

    Activities.controller = function($scope) {
      $scope.chuncksCompletedMonth = chuncksCompletedMonth;
      $scope.chuncksCompletedDay = chuncksCompletedDay;
      $scope.activities = activityList;
      return $scope.completeActivity = function() {
        $scope.chuncksCompletedMonth++;
        return $scope.chuncksCompletedDay++;
      };
    };

    return Activities;

  })();

}).call(this);
