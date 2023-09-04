'use strict'
angular.module('bahmni.common.displaycontrol.custom')
.directive('vaccination', ['observationsService', 'appService', 'spinner', 'printer', function (observationsService, appService, spinner, printer) {
    var link = function ($scope) {
        var conceptNames = ["COVID-19-Starter, Vaccine"];
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/vaccination.html";
        $scope.certificateUrl = appService.configBaseUrl() + "/customDisplayControl/views/covid19VaccineCertificate.html";
        $scope.observationData = [];
        spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, undefined, undefined, $scope.visitUuid, undefined).then(function (response) {
            $scope.observationData = response.data[0];
            $scope.dosages = {};
            if ($scope.observationData != null) {
                for (var i=0; i<$scope.observationData.groupMembers.length; i++) {
                    var groupMember = $scope.observationData.groupMembers[i];
                    if (groupMember.concept.name === 'COVID-19-Starter, COVID-19 Vaccine Name') {
                        $scope.dosages.vaccineName = groupMember.valueAsString;
                    }
                    if (groupMember.concept.name === 'VACCINE MANUFACTURER') {
                        $scope.dosages.manufacturer = groupMember.valueAsString;
                    }
                    if (groupMember.concept.name.startsWith('COVID-19-Starter, Dose')) {
                        var isDose1 = groupMember.concept.name === 'COVID-19-Starter, Dose-1' ? true : false;
                        if (isDose1) {
                            $scope.dosages.dose1 = {};
                        } else {
                            $scope.dosages.dose2 = {};
                        }
                        for (var j=0; j<groupMember.groupMembers.length; j++) {
                            if (groupMember.groupMembers[j].concept.name === 'VACCINE LOT NUMBER') {
                                if (isDose1) {
                                    $scope.dosages.dose1.lotNumber = groupMember.groupMembers[j].valueAsString;
                                    $scope.dosages.dose1.date = groupMember.groupMembers[j].visitStartDateTime;
                                } else {
                                    $scope.dosages.dose2.lotNumber = groupMember.groupMembers[j].valueAsString;
                                    $scope.dosages.dose2.date = groupMember.groupMembers[j].visitStartDateTime;
                                }
                            }
                            if (groupMember.groupMembers[j].concept.name === 'Date medication refills due') {
                                if (isDose1) {
                                    $scope.dosages.dose1.dueDate = groupMember.groupMembers[j].valueAsString;
                                } else {
                                    $scope.dosages.dose2.dueDate = groupMember.groupMembers[j].valueAsString;
                                }
                            }
                        }
                    }
                }
            }
        }));
        $scope.print = function () {
            printer.print(appService.configBaseUrl() + "/customDisplayControl/views/printVaccination.html", {patient: $scope.patient, dosages: $scope.dosages, currentDashboardTemplateUrl: $scope.certificateUrl});
        };
    };
    return {
        restrict: 'E',
        template: '<ng-include src="contentUrl"/>',
        link: link
    }
}]);