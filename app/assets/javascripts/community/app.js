(function() {

	'use strict'

	angular.module('community', [
		'ngRoute', 'ngResource', 'ngSanitize',
		'ui.select', 'pascalprecht.translate',
		'utils', 'users', 'company', 'messages',
		'search', 'view', 'new', 'firebase',
		'angular-loading-bar'
	])
		.config(['cfpLoadingBarProvider', function (cfpLoadingBarProvider) {
			cfpLoadingBarProvider.includeSpinner = true;
			cfpLoadingBarProvider.includeBar = false;
		}])
		.config(['$httpProvider', '$translateProvider',
			function($httpProvider, $translateProvider) {

				$httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = $('meta[name=csrf-token]').attr('content')
				$httpProvider.defaults.headers.common['X-Requested-With'] = 'AngularXMLHttpRequest'

				Stripe.setPublishableKey(GREENFENCE.stripe_key.publishable);

				$translateProvider
				  	.useStaticFilesLoader({
		          		prefix: '/community/common/locale-',
		          		suffix: '.json'
		        	})
				  	.preferredLanguage('ln');
			}
		])
        .run(function($rootScope, $location) {
            $rootScope.$on("$routeChangeStart", function(event, next, current) {
				var path = $location.path();
				var req = /([^\/]+)/g;

				var path_last = path.match(req)[0];

				if (path_last == 'add_supply_chain') {
					path_last = path.match(req)[1];

				} else if (path_last == 'company_public_profile' && path.match(req)[1] == 'filter') {
					path_last = path.match(req)[2];
				}

				else if (path_last == 'operation_public_profile' && path.match(req)[2] == 'filter') {
					path_last = path.match(req)[3];
				}

				//$rootScope.current_location = $location.path().split('/').pop();
				$rootScope.current_location = path_last;
				console.log('path',path_last, path.match(req)[0], path.match(req)[1], path.match(req)[2], path.match(req)[3]);
                $rootScope.modifier = {
                    layout: 'layuot_mod_1',
                    base: 'layuot_mod_1',
                    wrap: 'layuot_mod_1',
                    main_row: 'layuot_mod_1'
                }
            });
        });

	angular.module('community').controller('HomeCtrl', ['$rootScope', '$scope', '$timeout', '$location', 'ui', 'UserService', 'ProductService', 'CompanyService', 'MessageService', 'ss_alert',
		function($rootScope, $scope, $timeout, $location, ui, UserService, ProductService, CompanyService, MessageService, ss_alert) {

			$scope.template = {
				header : '/community/common/header',
				slider: '',
				rightmenu: '',
				footer: ''
			}

			$rootScope.userId = $('#user_id').val();
			$rootScope.default_avatar_image = GREENFENCE.default_avatar.url;
			$rootScope.unread_in_messages = [];
			$rootScope.unread_requests = [];
			$rootScope.unread_notifications = [];

			var menu_nav, menu_button, wizard, sub_menu;
			$scope.user_welcome_message_closed = false
			$scope.close_butt = function($event) {

				$rootScope.user.is_welcome_message_closed = true;
				$('.b_block_close_butt').trigger('click');

				UserService.update($rootScope.user).$promise.then(function(data) {

				})
			}

			$scope.menu = function() {
				menu_nav = $('#menu_nav')
				menu_button = $('#menu_button')
				if (menu_button.hasClass('active_mod')) {
					menu_nav.removeClass('active_mod')
					menu_button.removeClass('active_mod')
				} else {
					menu_nav.addClass('active_mod')
					menu_button.addClass('active_mod')
				}
			}

			$scope.wizard = function() {
				wizard = $('#wizard');
				sub_menu = $('#sub_menu');

				if (wizard.hasClass('active_mod')) {
					wizard.removeClass('active_mod');
					sub_menu.slideUp(400);
				}
				else {
					wizard.addClass('active_mod');
					sub_menu.slideDown(400);
				}

				return false;
			}

			var ref = new Firebase( GREENFENCE.firebase_uri.notification );

			ref.limitToLast(1).on('child_added', function(snapshot) {

      		var added_msg = snapshot.val();

	        if ( $.inArray( parseInt($rootScope.userId), added_msg.receiver_ids ) > -1 ) {

		        MessageService.unreadInMessages().$promise.then(function(data) {
						  $rootScope.unread_in_messages = data;
				    });

				    MessageService.unreadRequests().$promise.then(function(data) {
				        $rootScope.unread_requests = data;
				    });

				    MessageService.unreadNotifications().$promise.then(function(data) {
				        $rootScope.unread_notifications = data;
				    });
		      }

		    });

		    $timeout(function(){
		     	$(document).trigger('ready_view');
				//var invite_users = new dialog('#invite_users', 'dialog_v1 invite_users_dialog no_close_mod no_title_mod dialog_color_schema_1_mod dialog_g_size_1', '.invite_employees_butt', false, '510', false);
	       }, 8000);

			ProductService.companyProducts().$promise.then(function(data) {
				$rootScope.company_products = data
			})

			// should be optimized for single call.
			CompanyService.get({id: null}).$promise.then(function(data) {
				$rootScope.current_company = data;
			})

			UserService.get({id: $rootScope.userId}).$promise.then(function(data) {
				$rootScope.user = data;
			})

			// get all the in messages of the current user
			MessageService.unreadInMessages().$promise.then(function(data) {
				$rootScope.unread_in_messages = data;
    	})

    	MessageService.unreadRequests().$promise.then(function(data) {
      	$rootScope.unread_requests = data;
    	})

    	MessageService.unreadNotifications().$promise.then(function(data) {
      	$rootScope.unread_notifications = data;
    	})

			$scope.search = function(query) {
				if (query) {
					$location.url('/search?q=' + query)
				} else {
					ss_alert.alert("error", "Please enter a valid string to search.")
				}
			}

      $scope.read_all_messages = function() {
		  all_dialog_close_gl();

        MessageService.markRead({unread_object: "messages"}).$promise.then(function(data) {
          $rootScope.unread_in_messages = [];
          console.log("mark unread messages as read successfully");
        })


        $location.path('/messages_center/filter/messages')
      }

      $scope.read_all_invitations = function() {
		  all_dialog_close_gl();
        MessageService.markRead({unread_object: "requests"}).$promise.then(function(data) {
          $rootScope.unread_requests = [];
          console.log("mark unread requests as read successfully");
        })

        $location.path('/messages_center/filter/requests')
      }

      $scope.read_all_notifications = function() {
		  all_dialog_close_gl();
        MessageService.markRead({unread_object: "notifications"}).$promise.then(function(data) {
          $rootScope.unread_notifications = [];
          console.log("mark unread notifications as read successfully");
        })

        $location.path('/messages_center/filter/notifications')
      }
		}
	])

	angular.module('community').directive('gfEnter', function() {
        return function(scope, element, attrs) {
            element.bind("keydown keypress", function(event) {
                if (event.which === 13) {
                    scope.$apply(function() {
                        scope.$eval(attrs.gfEnter, {
                            'event': event
                        });
                    })
                    event.preventDefault()
                }
            })
        }
    })

    angular.module('community').directive('gfNumberInput', function() {
        return {
            restrict: 'A',
            require: '?ngModel',
            link: function(scope, element, attrs, ngModel) {
                if (!ngModel) return;
                var max = null
                if (attrs.maxlength) {
                    max = Number(attrs.maxlength);
                }
                ngModel.$parsers.unshift(function(inputValue) {
                    var digits = inputValue.split('').filter(function(s) {
                        return (!isNaN(s) && s != ' ');
                    }).join('');
                    if (max && String(inputValue).length > max) return;
                    ngModel.$setViewValue(digits)
                    ngModel.$render()
                    return digits
                })
            }
        }
    })

    angular.module('community').directive('gfCharInput', function() {
        return {
            restrict: 'A',
            require: '?ngModel',
            link: function(scope, element, attrs, ngModel) {
                if (!ngModel) return;
                ngModel.$parsers.unshift(function(inputValue) {
                    var chars = inputValue.replace(/[^A-Za-z ]/g, '');
                    ngModel.$setViewValue(chars)
                    ngModel.$render()
                    return chars
                })
            }
        }
    })

    angular.module('community').filter('page_filter', function() {
        return function(input, start) {
            if (input === undefined) {
                return input;
            } else {
                return input.slice(start);
            }
        };
    });

    angular.module('community').filter('timeAgo', function() {
        return function (s) {

			var date = new Date(s);
			var now = new Date();

			var diffMs = Math.abs(now - date);

			var secondsAgo = Math.floor(diffMs / 1000);
			var minutesAgo = Math.floor(secondsAgo / 60);
			var hoursAgo = Math.floor(minutesAgo / 60);
			var daysAgo = Math.floor(hoursAgo / 24);

			var timeAgoString;

			if (daysAgo != 0) {
				timeAgoString = daysAgo + ' days ago';
			} else if (hoursAgo != 0) {
				timeAgoString = hoursAgo + ' hours ago';
			} else if (minutesAgo != 0) {
				timeAgoString = minutesAgo + ' minutes ago';
			} else {
				timeAgoString = 'Just now';
			}

			return timeAgoString;
		};
    });

    angular.module('community').directive("gfTextInput", function() {
        return {
            restrict: "E",
            scope: {
                id: "=id",
                ptitle: "=pTitle",
                model: "=model",
                dlclass: "=dlClass",
                containersclass: "=containersClass",
                fieldclass: "=fieldClass"
            },
            templateUrl: '/community/new/gf_text_input'
        }
    });

	angular.module('community').directive("gfWizardsBlock", function() {
		return {
			restrict: "E",
			scope: {
				blockview:"=blockView",
				hline:"=hLine",
				fcontent: "=fContent",
				required: "=required",
				id: "=id",
				ptitle: "=pTitle",
				model: "=model",
				dlclass: "=dlClass",
				containersclass: "=containersClass",
				fieldclass: "=fieldClass"
			},
			templateUrl: '/community/new/gf_wizards_block'
		}
	});
})();
