#pragma once
//------------------------------------------------------------------------------
/**
    @class Oryol::_priv::inputMgr
    @ingroup _priv
    @brief frontend inputMgr class
*/
#if ORYOL_UWP
#include "Input/uwp/uwpInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public uwpInputMgr { };
} }
#elif ORYOL_D3D11
#include "Input/win/winInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public winInputMgr { };
} }
#elif ORYOL_MACOS && ORYOL_METAL
#include "Input/osx/osxInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public osxInputMgr { };
} }
#elif ORYOL_RASPBERRYPI
#include "Input/raspi/raspiInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public raspiInputMgr { };
} }
#elif (ORYOL_WINDOWS || ORYOL_MACOS || ORYOL_LINUX)
#include "Input/glfw/glfwInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public glfwInputMgr { };
} }
#elif ORYOL_EMSCRIPTEN
#include "Input/emsc/emscInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public emscInputMgr { };
} }
#elif ORYOL_PNACL
#include "Input/pnacl/pnaclInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public pnaclInputMgr { };
} }
#elif ORYOL_ANDROID
#include "Input/android/androidInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public androidInputMgr { };
} }
#elif ORYOL_IOS
#include "Input/ios/iosInputMgr.h"
namespace Oryol {
namespace _priv {
class inputMgr : public iosInputMgr { };
} }
#else
#include "Input/base/inputMgrBase.h"
namespace Oryol {
namespace _priv {
class inputMgr : public inputMgrBase { };
} }
#endif
