classdef PlanarClassDefinition
    
    properties
        fqClassName = '';
        
        planarClassOptions = {};
        planarIdentityFields = {};
        planarFields = {};
        planarNanFields = {};
        planarNoNanFields = {};
        planarNanFlags = {};
        planarNanFlag = [];
        hasPlanarNanFlag = false;
        
        doSetops = false;
        
        isHandle = false;
        usesPlanarClassBase = false;
        userMethodNames = {};
        hasUserSubsref = false;
        hasUserSubsasgn = false;
        hasUserNumArgumentsFromSubscript = false;
        
        codeInfo
    end
end