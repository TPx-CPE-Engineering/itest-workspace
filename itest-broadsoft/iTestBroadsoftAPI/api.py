from broadworks_ocip import BroadworksAPI, OCIErrorResponse
import broadworks_ocip.types as broadsoft_types


class ITestBroadworksAPI(BroadworksAPI):
    domain = '@lab-sv.telepacific.com'

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @staticmethod
    def parse_broadsoft_error(error):
        print(f"Broadsoft OCI API Error Response: {error.message}")
        return

    def delete_all_user_schedules(self, phone_number):
        """
        Delete all schedules for user
        :param phone_number: Phone number of user, must be within self.domain
        :return: None
        """
        from broadworks_ocip.types import ScheduleKey

        user_id = phone_number + self.domain

        response = self.command('UserScheduleGetListRequest',
                                user_id=user_id)

        # if theres no schedules return
        if not response.schedule_name:
            print(f'No User Schedules for: {phone_number}')
            return

        schedule_keys_to_del = []
        for schedule_name, schedule_type in zip(response.schedule_name, response.schedule_type):
            schedule_keys_to_del.append(ScheduleKey(schedule_name=schedule_name,
                                                    schedule_type=schedule_type))

        for key in schedule_keys_to_del:
            try:
                self.command('UserScheduleDeleteListRequest',
                             user_id=user_id,
                             schedule_key=key)
            except OCIErrorResponse as e:
                self.parse_broadsoft_error(error=e)

    def set_user_anonymous_rejection(self, phone_number, is_active:bool):
        """
        Set Anonymous Rejection for user
        :param phone_number: Phone number of user_id, must be within self.domain
        :param is_active: Set activation (True or False) for anonymous call rejection
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserAnonymousCallRejectionModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_calling_name_delivery(self, phone_number, is_active_for_external_calls:bool,
                                       is_active_for_internal_calls:bool):
        """
        Set Calling Name Delivery (external calls & internal calls) for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active_for_external_calls: Set activation (True or False) for external calling name delivery
        :param is_active_for_internal_calls: Set activation (True of False) for internal calling name delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallingNameDeliveryModifyRequest',
                                user_id=user_id,
                                is_active_for_external_calls=is_active_for_external_calls,
                                is_active_for_internal_calls=is_active_for_internal_calls)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_calling_name_retrieval(self, phone_number, is_active:bool):
        """
        Set Calling Name Retrieval for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for calling name retrieval
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallingNameRetrievalModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_calling_number_delivery(self, phone_number, is_active_for_external_calls:bool,
                                         is_active_for_internal_calls:bool):
        """
        Set Calling Number Delivery (external calls & internal calls) for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active_for_external_calls: Set activation (True or False) for external calling number delivery
        :param is_active_for_internal_calls: Set activation (True or False) for internal calling number delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain
        try:
            return self.command('UserCallingNumberDeliveryModifyRequest',
                                user_id=user_id,
                                is_active_for_external_calls=is_active_for_external_calls,
                                is_active_for_internal_calls=is_active_for_internal_calls)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_call_forwarding_always(self, phone_number, is_active:bool):
        """
        Set Call Forwarding Always for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for call forwarding always
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallForwardingAlwaysModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_call_forwarding_busy(self, phone_number, is_active:bool, forward_to_phone_number:str = None):
        """
        Set Call Forwarding Busy for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for call forwarding busy
        :param forward_to_phone_number: if activation set to True, phone number to forward call to
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallForwardingBusyModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                forward_to_phone_number=forward_to_phone_number)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_call_forwarding_no_answer(self, phone_number, is_active:bool, forward_to_phone_number:str = None,
                                           number_of_rings:int = None):
        """
        Set Call Forwarding No Answer for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for call forwarding no answer
        :param forward_to_phone_number: If activation set to True, phone number to forward call to
        :param number_of_rings: If activation set to True, number of rings before forwarding
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallForwardingNoAnswerModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                forward_to_phone_number=forward_to_phone_number,
                                number_of_rings=number_of_rings)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_call_forwarding_not_reachable(self, phone_number, is_active:bool, forward_to_phone_number:str = None):
        """
        Set Call Forwarding Not Reachable for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for call forwarding not reachable
        :param forward_to_phone_number: If activation set to True, phone number to forward call to
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallForwardingNotReachableModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                forward_to_phone_number=forward_to_phone_number)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_do_not_disturb(self, phone_number, is_active:bool, ring_splash:bool = None):
        """
        Set Do Not Disturb for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for do not disturb
        :param ring_splash: Set activation (True or False) to play ring reminder when a call is blocked
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserDoNotDisturbModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                ring_splash=ring_splash)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_external_calling_line_id_delivery(self, phone_number, is_active:bool):
        """
        Set External Calling Line ID Delivery for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for external calling line id delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserExternalCallingLineIDDeliveryModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_internal_calling_line_id_delivery(self, phone_number, is_active:bool):
        """
        Set Internal Calling Line ID Delivery for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for internal calling line id delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserInternalCallingLineIDDeliveryModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_call_forwarding_selective(self, phone_number, is_active:bool,
                                           default_forward_to_phone_number:str = None, play_ring_reminder:bool = None,
                                           criteria_activation:[broadsoft_types.CriteriaActivation] = None):
        """
        Set Call Forwarding Selective for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for call forwarding selective
        :param default_forward_to_phone_number: Phone number to call forward to
        :param play_ring_reminder: Set activation (True or False) to play ring reminder
        :param criteria_activation: List of Criteria Activation
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallForwardingSelectiveModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                default_forward_to_phone_number=default_forward_to_phone_number,
                                play_ring_reminder=play_ring_reminder,
                                criteria_activation=criteria_activation)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_selective_acceptance(self, phone_number,
                                      criteria_activation:[broadsoft_types.CriteriaActivation] = None):
        """
        Set User Selective Acceptance for user
        :param phone_number: Phone number of user, must be within self.domain
        :param criteria_activation: List of Criteria Activation
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserSelectiveCallAcceptanceModifyActiveCriteriaListRequest',
                                user_id=user_id,
                                criteria_activation=criteria_activation)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def delete_all_user_selective_acceptance(self, phone_number):
        """
        Delete all entries in Selective Call Acceptance
        :param phone_number: Phone number of user, must be within self.domain
        :return: None
        """

        user_id = phone_number + self.domain

        try:
            selective_call_acceptance = self.command('UserSelectiveCallAcceptanceGetCriteriaListRequest',
                                                     user_id=user_id)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

        for entry in selective_call_acceptance.criteria_table:
            try:
                self.command('UserSelectiveCallAcceptanceDeleteCriteriaRequest',
                             user_id=user_id,
                             criteria_name=entry[1])
            except OCIErrorResponse as e:
                self.parse_broadsoft_error(error=e)

    def delete_all_user_sequential_rings(self, phone_number):
        """
        Delete all entries for Sequential Rings for user
        :param phone_number: Phone number of user, must be within self.domain
        :return: None
        """

        user_id = phone_number + self.domain

        try:
            sequential_rings = self.command('UserSequentialRingGetRequest13mp16',
                                            user_id=user_id)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

        for entry in sequential_rings.criteria_table:
            try:
                self.command('UserSequentialRingDeleteCriteriaRequest',
                             user_id=user_id,
                             criteria_name=entry[1])
            except OCIErrorResponse as e:
                self.parse_broadsoft_error(error=e)

    def set_all_user_simultaneous_ring_personal(self, phone_number, is_active:bool, incoming_calls:str = None,
                                                sim_ring_phone_number_list:
                                                [broadsoft_types.ReplacementOutgoingDNorSIPURIList] = None):
        """
        Set Simultaneous Ring Personal for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for simultaneous ring personal
        :param incoming_calls: List of phone numbers to simultaneous ring
        :param sim_ring_phone_number_list: List of sim ring phone numbers
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserSimultaneousRingPersonalModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                incoming_calls=incoming_calls,
                                sim_ring_phone_number_list=sim_ring_phone_number_list)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_calling_line_id_delivery(self, phone_number, is_active:bool):
        """
        Set Calling Line ID Delivery for user
        :param phone_number: Phone number of user, must be within self.domain
        :param is_active: Set activation (True or False) for calling line id delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallingLineIDDeliveryBlockingModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def delete_all_user_speed_dial_100(self, phone_number):
        """
        Delete all Speed Dial 100 entries for user
        :param phone_number: Phone number of user, user must be within self.domain
        :return: None
        """

        user_id = phone_number + self.domain

        speed_dial_100 = self.command('UserSpeedDial100GetListRequest',
                                      user_id=user_id)

        while speed_dial_100.speed_dial_entry:
            speed_code = speed_dial_100.speed_dial_entry.speed_code

            try:
                self.command('UserSpeedDial100DeleteListRequest',
                             user_id=user_id,
                             speed_code=speed_code)
            except OCIErrorResponse as e:
                self.parse_broadsoft_error(error=e)

            speed_dial_100 = self.command('UserSpeedDial100GetListRequest',
                                          user_id=user_id)

    def set_user_call_waiting(self, phone_number, is_active:bool, disable_calling_line_id_delivery:bool = None):
        """
        Set Call Waiting for user
        :param phone_number: Phone number of user, user must be within self.domain
        :param is_active: Set activation (True or False) for call waiting
        :param disable_calling_line_id_delivery: Set activation (True or False) for calling line id delivery
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserCallWaitingModifyRequest',
                                user_id=user_id,
                                is_active=is_active,
                                disable_calling_line_id_delivery=disable_calling_line_id_delivery)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_music_on_hold(self, phone_number, is_active:bool):
        """
        Set Music on Hold for user
        :param phone_number: Phone number of user, user must be within self.domain
        :param is_active: Set activation (True or False) for music on hold
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserMusicOnHoldModifyRequest',
                                user_id=user_id,
                                is_active=is_active)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)

    def set_user_incoming_calling_plan(self, phone_number, use_custom_settings:bool):
        """
        Set Incoming Calling Plan for user
        :param phone_number: Phone number of user, user must be within self.domain
        :param use_custom_settings: Set activation (True or False)
        :return: SuccessResponse() or ErrorResponse()
        """

        user_id = phone_number + self.domain

        try:
            return self.command('UserIncomingCallingPlanModifyRequest',
                                user_id=user_id,
                                use_custom_settings=use_custom_settings)
        except OCIErrorResponse as e:
            return self.parse_broadsoft_error(error=e)
