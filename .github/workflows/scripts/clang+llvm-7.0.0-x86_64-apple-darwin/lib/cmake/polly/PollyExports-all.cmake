set_target_properties(LLVMPolly PROPERTIES
        IMPORTED_LOCATION_<UPPER_CASE:Release ${CMAKE_CURRENT_LIST_DIR}/../../LLVMPolly.so)
set_target_properties(PollyISL PROPERTIES
        IMPORTED_LOCATION_<UPPER_CASE:Release ${CMAKE_CURRENT_LIST_DIR}/../../libPollyISL.a)
set_target_properties(Polly PROPERTIES
        IMPORTED_LOCATION_<UPPER_CASE:Release ${CMAKE_CURRENT_LIST_DIR}/../../libPolly.a)
