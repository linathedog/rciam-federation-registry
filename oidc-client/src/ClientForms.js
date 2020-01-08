import React,{useEffect,useState} from 'react';
import initialValues from './initialValues';
import * as config from './config.json';
import {useParams} from "react-router-dom";
import FormTabs from "./FormTabs.js";
import ClientList from "./ClientList.js";

const EditClient = (props) => {
  const [initData,setInitData] = useState();

  let { id } = useParams();
  useEffect(()=>{
    console.log(initialValues);
    getInitialValues();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  },[]);
  const getInitialValues = () => {
    fetch(config.host+'getclient/'+id, {
      method: 'GET', // *GET, POST, PUT, DELETE, etc.
      credentials: 'include', // include, *same-origin, omit
      headers: {
        'Content-Type': 'application/json'
      }
    }).then(response=>response.json()).then(response=> {
      if(response.success){
          setInitData(response.connection);
          console.log('we have data')
      }
      else{
        setInitData(initialValues)
      }
    });
  }
  return (
    <React.Fragment>
      {initData?<FormTabs initialValues={initData} title={"Edit Client"}/>:<ClientList/>}
    </React.Fragment>
  )
}

const NewClient = ()=>{
  return <FormTabs initialValues={initialValues} title={"New Client"}/>
}

export {
   EditClient,
   NewClient
}