class NotificationSettingsModel {
  int? id;
  int? userId;
  int? generalUpdates;
  int? safetySecurityAlerts;
  int? accountNotifications;
  int? rideStatusUpdates;
  int? promoAlerts;
  int? ratingReviews;
  int? personalizedRecommendations;
  int? appUpdates;
  int? serviceUpdates;
  int? communityForumActivity;
  int? surveyFeedbackRequests;
  int? importantAnnouncements;
  int? appTipsTutorials;
  String? createdAt;
  String? updatedAt;

  NotificationSettingsModel({
    this.id,
    this.userId,
    this.generalUpdates,
    this.safetySecurityAlerts,
    this.accountNotifications,
    this.rideStatusUpdates,
    this.promoAlerts,
    this.ratingReviews,
    this.personalizedRecommendations,
    this.appUpdates,
    this.serviceUpdates,
    this.communityForumActivity,
    this.surveyFeedbackRequests,
    this.importantAnnouncements,
    this.appTipsTutorials,
    this.createdAt,
    this.updatedAt,
  });

  NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    generalUpdates = json['general_updates'];
    safetySecurityAlerts = json['safety_security_alerts'];
    accountNotifications = json['account_notifications'];
    rideStatusUpdates = json['ride_status_updates'];
    promoAlerts = json['promo_alerts'];
    ratingReviews = json['rating_reviews'];
    personalizedRecommendations = json['personalized_recommendations'];
    appUpdates = json['app_updates'];
    serviceUpdates = json['service_updates'];
    communityForumActivity = json['community_forum_activity'];
    surveyFeedbackRequests = json['survey_feedback_requests'];
    importantAnnouncements = json['important_announcements'];
    appTipsTutorials = json['app_tips_tutorials'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['user_id'] = userId;
    data['general_updates'] = generalUpdates;
    data['safety_security_alerts'] = safetySecurityAlerts;
    data['account_notifications'] = accountNotifications;
    data['ride_status_updates'] = rideStatusUpdates;
    data['promo_alerts'] = promoAlerts;
    data['rating_reviews'] = ratingReviews;
    data['personalized_recommendations'] =
        personalizedRecommendations;
    data['app_updates'] = appUpdates;
    data['service_updates'] = serviceUpdates;
    data['community_forum_activity'] =
        communityForumActivity;
    data['survey_feedback_requests'] =
        surveyFeedbackRequests;
    data['important_announcements'] =
        importantAnnouncements;
    data['app_tips_tutorials'] = appTipsTutorials;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}