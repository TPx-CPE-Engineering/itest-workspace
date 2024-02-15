from iTestBroadsoftAPI.api import ITestBroadworksAPI
import xmltodict

HOST = '10.255.10.163'
USERNAME = 'itestautomation'
PASSWORD = 'iTest@123'

ITEST_BROADWORKS_API = ITestBroadworksAPI(host=HOST,
                                          username=USERNAME,
                                          password=PASSWORD)


def delete_all_user_schedules(phone_number):
    ITEST_BROADWORKS_API.delete_all_user_schedules(phone_number=phone_number)


def disable_anonymous_rejection(phone_number):
    ITEST_BROADWORKS_API.set_user_anonymous_rejection(phone_number=phone_number,
                                                      is_active=False)


def enable_calling_name_delivery(phone_number):
    ITEST_BROADWORKS_API.set_user_calling_name_delivery(phone_number=phone_number,
                                                        is_active_for_external_calls=True,
                                                        is_active_for_internal_calls=True)


def enable_calling_name_retrieval(phone_number):
    ITEST_BROADWORKS_API.set_user_calling_name_retrieval(phone_number=phone_number,
                                                         is_active=True)


def enable_calling_number_delivery(phone_number):
    ITEST_BROADWORKS_API.set_user_calling_number_delivery(phone_number=phone_number,
                                                          is_active_for_internal_calls=True,
                                                          is_active_for_external_calls=True)


def disable_call_forwarding_always(phone_number):
    ITEST_BROADWORKS_API.set_user_call_forwarding_always(phone_number=phone_number,
                                                         is_active=False)


def disable_call_forwarding_busy(phone_number):
    ITEST_BROADWORKS_API.set_user_call_forwarding_busy(phone_number=phone_number,
                                                       is_active=False)


def disable_call_forwarding_no_answer(phone_number):
    ITEST_BROADWORKS_API.set_user_call_forwarding_no_answer(phone_number=phone_number,
                                                            is_active=False,
                                                            number_of_rings=2)


def disable_call_forwarding_not_reachable(phone_number):
    ITEST_BROADWORKS_API.set_user_call_forwarding_not_reachable(phone_number=phone_number,
                                                                is_active=False)


def disable_do_not_disturb(phone_number):
    ITEST_BROADWORKS_API.set_user_do_not_disturb(phone_number=phone_number,
                                                 is_active=False)


def disable_external_calling_line_id_delivery(phone_number):
    ITEST_BROADWORKS_API.set_user_external_calling_line_id_delivery(phone_number=phone_number,
                                                                    is_active=False)


def disable_internal_calling_line_id_delivery(phone_number):
    ITEST_BROADWORKS_API.set_user_internal_calling_line_id_delivery(phone_number=phone_number,
                                                                    is_active=False)


def disable_call_forwarding_selective(phone_number):
    ITEST_BROADWORKS_API.set_user_call_forwarding_selective(phone_number=phone_number,
                                                            is_active=False)


def delete_all_selective_acceptance(phone_number):
    ITEST_BROADWORKS_API.delete_all_user_selective_acceptance(phone_number=phone_number)


def delete_all_user_sequential_rings(phone_number):
    ITEST_BROADWORKS_API.delete_all_user_sequential_rings(phone_number=phone_number)


def disable_user_simultaneous_ring_personal(phone_number):
    ITEST_BROADWORKS_API.set_all_user_simultaneous_ring_personal(phone_number=phone_number,
                                                                 is_active=False)


def disable_user_calling_line_id_delivery(phone_number):
    ITEST_BROADWORKS_API.set_user_calling_line_id_delivery(phone_number=phone_number,
                                                           is_active=False)

# Could not complete DELETE SPEED DIAL 8


def delete_user_all_speed_dial_100(phone_number):
    ITEST_BROADWORKS_API.delete_all_user_speed_dial_100(phone_number=phone_number)


def disable_user_call_waiting(phone_number):
    ITEST_BROADWORKS_API.set_user_call_waiting(phone_number=phone_number,
                                               is_active=False)


def disable_user_music_on_hold(phone_number):
    ITEST_BROADWORKS_API.set_user_music_on_hold(phone_number=phone_number,
                                                is_active=False)


def disable_custom_settings_for_user_incoming_calling_plan(phone_number):
    ITEST_BROADWORKS_API.set_user_incoming_calling_plan(phone_number=phone_number,
                                                        use_custom_settings=False)


# CHANGE OF STYLE
# API CALLS ON OBJECT ARE TAKING TOO LONG
def disable_custom_settings_For_user_outgoing_calling_plan(phone_number):
    user_id = phone_number + ITEST_BROADWORKS_API.domain

    ITEST_BROADWORKS_API.command('UserOutgoingCallingPlanOriginatingModifyRequest',
                                 user_id=user_id,
                                 use_custom_settings=False)


def disable_user_voice_messaging(phone_number):
    user_id = phone_number + ITEST_BROADWORKS_API.domain

    ITEST_BROADWORKS_API.command('UserVoiceMessagingUserModifyVoiceManagementRequest',
                                 user_id=user_id,
                                 is_active=False)


def delete_all_group_schedules(enterprise_name, group_name):
    response = ITEST_BROADWORKS_API.command('GroupScheduleGetListRequest',
                                            service_provider_id=enterprise_name,
                                            group_id=group_name)

    if response.schedule_name is None:
        return

    schedule_keys_to_del = []
    for schedule_name, schedule_type in zip(response.schedule_name, response.schedule_type):
        schedule_keys_to_del.append(ITEST_BROADWORKS_API.get_type_object('ScheduleKey',
                                                                         schedule_name=schedule_name,
                                                                         schedule_type=schedule_type))

    for key in schedule_keys_to_del:
        # Get events in each schedule
        response = ITEST_BROADWORKS_API.command('GroupScheduleGetEventListRequest',
                                                service_provider_id=enterprise_name,
                                                group_id=group_name,
                                                schedule_key=key)
        events = response.event_name
        # Delete every event within each schedule before deleting schedules
        if events is not None:
            for event_name in events:
                ITEST_BROADWORKS_API.command('GroupScheduleDeleteEventListRequest',
                                             service_provider_id=enterprise_name,
                                             group_id=group_name,
                                             schedule_key=key,
                                             event_name=event_name)

        # Delete schedule
        ITEST_BROADWORKS_API.command('GroupScheduleDeleteListRequest',
                                     service_provider_id=enterprise_name,
                                     group_id=group_name,
                                     schedule_key=key)


def set_group_call_processing(enterprise_name, group_name):
    ITEST_BROADWORKS_API.command('GroupCallProcessingModifyPolicyRequest15sp2',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 use_group_clid_setting=False,
                                 use_group_name=False)


def set_group_auth_codes_administration(enterprise_name, group_name):
    ITEST_BROADWORKS_API.command('GroupAccountAuthorizationCodesModifyRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 code_type='Deactivated',
                                 allow_local_and_toll_free_calls=False)


def delete_all_group_auth_codes_codes_managements(enterprise_name, group_name):
    response = ITEST_BROADWORKS_API.command('GroupAccountAuthorizationCodesGetListRequest',
                                            service_provider_id=enterprise_name,
                                            group_id=group_name,
                                            decode_xml=False)

    # Broadworks API has cannot parse the response correctly, going to use different lib to convert it into a dict
    # and extract code names needed to delete them
    group_account_authorization_codes = xmltodict.parse(response)

    codes = group_account_authorization_codes['BroadsoftDocument']['command'].get('codeEntry', [])

    # Delete every code
    for code in codes:
        ITEST_BROADWORKS_API.command('GroupAccountAuthorizationCodesDeleteListRequest',
                                     service_provider_id=enterprise_name,
                                     group_id=group_name,
                                     code=code['code'])


def delete_all_group_digit_strings(enterprise_name, group_name):
    digit_strings = ITEST_BROADWORKS_API.command('GroupCallingPlanGetDigitPatternListRequest',
                                                 service_provider_id=enterprise_name,
                                                 group_id=group_name)

    for digit in digit_strings.digit_pattern_table:
        name = digit[0]
        ITEST_BROADWORKS_API.command('GroupCallingPlanDeleteDigitPatternListRequest',
                                     service_provider_id=enterprise_name,
                                     group_id=group_name,
                                     name=name)


def set_group_incoming_calling_plan(enterprise_name, group_name):
    group_permissions = ITEST_BROADWORKS_API.get_type_object('IncomingCallingPlanPermissionsModify',
                                                             allow_from_within_group=True,
                                                             allow_from_outside_group='Allow',
                                                             allow_collect_calls=False,
                                                             digit_pattern_permission=None)

    ITEST_BROADWORKS_API.command('GroupIncomingCallingPlanModifyListRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 group_permissions=group_permissions)


def set_group_outgoing_calling_plan(enterprise_name, group_name):

    # ORIGINATING
    group_permissions = ITEST_BROADWORKS_API.get_type_object('OutgoingCallingPlanOriginatingPermissionsModify',
                                                             group='Allow',
                                                             local='Allow',
                                                             toll_free='Allow',
                                                             toll='Disallow',
                                                             international='Disallow',
                                                             operator_assisted='Allow',
                                                             chargeable_directory_assisted='Allow',
                                                             special_services_i='Allow',
                                                             special_services_ii='Allow',
                                                             premium_services_i='Disallow',
                                                             premium_services_ii='Disallow',
                                                             casual='Allow',
                                                             url_dialing='Allow',
                                                             unknown='Allow')

    ITEST_BROADWORKS_API.command('GroupOutgoingCallingPlanOriginatingModifyListRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 group_permissions=group_permissions)

    # INITIATING CALL FORWARDS/TRANSFERS
    redirecting_group_permissions = ITEST_BROADWORKS_API.\
        get_type_object('OutgoingCallingPlanRedirectingPermissionsModify',
                        group=True,
                        local=True,
                        toll_free=True,
                        toll=False,
                        international=False,
                        operator_assisted=True,
                        chargeable_directory_assisted=True,
                        special_services_i=True,
                        special_services_ii=True,
                        premium_services_i=False,
                        premium_services_ii=False,
                        casual=True,
                        url_dialing=True,
                        unknown=True)

    ITEST_BROADWORKS_API.command('GroupOutgoingCallingPlanRedirectingModifyListRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 group_permissions=redirecting_group_permissions)

    # BEING FORWARDED/TRANSFERRED
    redirected_group_permissions = ITEST_BROADWORKS_API.\
        get_type_object('OutgoingCallingPlanRedirectedPermissionsModify',
                        outside_group=True)

    ITEST_BROADWORKS_API.command('GroupOutgoingCallingPlanRedirectedModifyListRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 group_permissions=redirected_group_permissions)


def set_group_intercept_group(enterprise_name, group_name):
    ITEST_BROADWORKS_API.command('GroupInterceptGroupModifyRequest',
                                 service_provider_id=enterprise_name,
                                 group_id=group_name,
                                 is_active=False)


def set_enterprise_voice_vpn(enterprise_name):
    ITEST_BROADWORKS_API.command('EnterpriseVoiceVPNModifyRequest',
                                 service_provider_id=enterprise_name,
                                 is_active=True,
                                 default_selection='Public',
                                 e164_selection='Public',
                                 use_phone_context=False)

    # Modify Location Code: 5
    ITEST_BROADWORKS_API.command('EnterpriseVoiceVPNModifyPolicyRequest',
                                 service_provider_id=enterprise_name,
                                 location_dialing_code="5",
                                 min_extension_length=4,
                                 max_extension_length=4,
                                 policy_selection='Public')

    # Modify Location Code: 8
    ITEST_BROADWORKS_API.command('EnterpriseVoiceVPNModifyPolicyRequest',
                                 service_provider_id=enterprise_name,
                                 location_dialing_code="5",
                                 min_extension_length=4,
                                 max_extension_length=4,
                                 policy_selection='Public')


def delete_user_incoming_calls_call_forwarding_selective(phone_number):
    user_id = phone_number + ITEST_BROADWORKS_API.domain
    response = ITEST_BROADWORKS_API.command("UserCallForwardingSelectiveGetRequest",
                                            user_id=user_id)

    for criteria in response.criteria_table:
        ITEST_BROADWORKS_API.command('UserCallForwardingSelectiveDeleteCriteriaRequest',
                                     user_id=user_id,
                                     criteria_name=criteria.criteria_name)


def delete_group_series_completion_groups(enterprise_name, group_name):
    response = ITEST_BROADWORKS_API.command('GroupSeriesCompletionGetInstanceListRequest', service_provider_id=enterprise_name, group_id=group_name)

    for name in response.name:
        ITEST_BROADWORKS_API.command('GroupSeriesCompletionDeleteInstanceRequest', service_provider_id=enterprise_name, group_id=group_name, name=name)


if __name__ == '__main__':
    # delete_all_user_schedules(phone_number='7025634891')
    delete_user_incoming_calls_call_forwarding_selective(phone_number='7028534880')
    delete_all_group_schedules(enterprise_name='TPAC-LabG6-2', group_name='iTest_Trunk')
