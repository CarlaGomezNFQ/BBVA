global interface Clib_ISObjectFieldSetInclusionsSelector extends fflib_ISObjectSelector{
    List<clib_SObjectFieldSetInclusion__mdt> selectByDeveloperName(Set<String> stringSet);
    List<clib_SObjectFieldSetInclusion__mdt> selectBySObjectName(Set<String> stringSet);
}