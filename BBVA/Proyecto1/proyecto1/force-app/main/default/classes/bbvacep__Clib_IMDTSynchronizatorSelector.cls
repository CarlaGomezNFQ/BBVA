public interface Clib_IMDTSynchronizatorSelector extends fflib_ISObjectSelector{
    List<clib_Synchronizator__mdt> selectByDeveloperName(Set<String> stringSet);
    List<clib_Synchronizator__mdt> selectBySourceObjectName(Set<String> stringSet);
    List<clib_Synchronizator__mdt> selectBySourceObjectNameWithMappings(Set<String> stringSet);
}