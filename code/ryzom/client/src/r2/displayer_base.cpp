// Ryzom - MMORPG Framework <http://dev.ryzom.com/projects/ryzom/>
// Copyright (C) 2010  Winch Gate Property Limited
//
// This source file has been modified by the following contributors:
// Copyright (C) 2013  Laszlo KIS-ADAM (dfighter) <dfighter1985@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include "stdpch.h"
#include "displayer_base.h"
#include "instance.h"
//
#include "game_share/object.h"
//
#include "nel/gui/lua_ihm.h"
#include "nel/gui/interface_element.h"

#ifdef DEBUG_NEW
#define new DEBUG_NEW
#endif

namespace R2
{

uint CDisplayerBase::ObjCount = 0;

// *********************************************************************************************************
CDisplayerBase::CDisplayerBase() : _DisplayedInstance(NULL)
{
	++ ObjCount;
}

CDisplayerBase::~CDisplayerBase()
{
	nlassert(ObjCount > 0);
	-- ObjCount;
}



// *********************************************************************************************************
void CDisplayerBase::pushLuaAccess(CLuaState &ls)
{
	//H_AUTO(R2_CDisplayerBase_pushLuaAccess)
	CLuaIHM::pushReflectableOnStack(ls, this);
}

// *********************************************************************************************************
const CObjectTable &CDisplayerBase::getProps() const
{
	//H_AUTO(R2_CDisplayerBase_getProps)
	nlassert(getDisplayedInstance());
	const CObjectTable *props = getDisplayedInstance()->getObjectTable();
	static volatile bool dumpProps = false;
	if (dumpProps)
	{
		props->dump();
	}
	nlassert(props);
	return *props;
}

// *********************************************************************************************************
CLuaObject &CDisplayerBase::getLuaProjection()
{
	//H_AUTO(R2_CDisplayerBase_getLuaProjection)
	nlassert(getDisplayedInstance());
	return getDisplayedInstance()->getLuaProjection();
}


}


