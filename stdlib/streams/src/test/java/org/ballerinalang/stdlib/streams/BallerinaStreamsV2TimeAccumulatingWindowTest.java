/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.stdlib.streams;

import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

/**
 * This contains methods to test time accumulating window behaviour in Ballerina Streaming V2.
 *
 * @since 0.990.3
 */
public class BallerinaStreamsV2TimeAccumulatingWindowTest {
    private CompileResult result;

    @BeforeClass
    public void setup() {
        result = BCompileUtil.compile("test-src/streamingv2-time-accumulating-window-test.bal");
    }

    @Test(description = "Test Time accumulating window query")
    public void testTimeAccumulatingQuery() {
        BValue[] outputEmployeeEvents = BRunUtil.invoke(result, "startAccumulatingTimeWindowTest");
        Assert.assertNotNull(outputEmployeeEvents);

        Assert.assertEquals(outputEmployeeEvents.length, 6, "Expected events are not received");

        BMap<String, BValue> employee0 = (BMap<String, BValue>) outputEmployeeEvents[0];
        BMap<String, BValue> employee1 = (BMap<String, BValue>) outputEmployeeEvents[1];
        BMap<String, BValue> employee2 = (BMap<String, BValue>) outputEmployeeEvents[2];
        BMap<String, BValue> employee3 = (BMap<String, BValue>) outputEmployeeEvents[3];
        BMap<String, BValue> employee4 = (BMap<String, BValue>) outputEmployeeEvents[4];
        BMap<String, BValue> employee5 = (BMap<String, BValue>) outputEmployeeEvents[5];

        Assert.assertEquals(employee0.get("name").stringValue(), "Mohan");
        Assert.assertEquals(((BInteger) employee0.get("count")).intValue(), 1);

        Assert.assertEquals(employee1.get("name").stringValue(), "Raja");
        Assert.assertEquals(((BInteger) employee1.get("count")).intValue(), 2);

        Assert.assertEquals(employee2.get("name").stringValue(), "Naveen");
        Assert.assertEquals(((BInteger) employee2.get("count")).intValue(), 1);

        Assert.assertEquals(employee3.get("name").stringValue(), "Amal");
        Assert.assertEquals(((BInteger) employee3.get("count")).intValue(), 2);

        Assert.assertEquals(employee4.get("name").stringValue(), "Nimal");
        Assert.assertEquals(((BInteger) employee4.get("count")).intValue(), 3);

        Assert.assertEquals(employee5.get("name").stringValue(), "Kavindu");
        Assert.assertEquals(((BInteger) employee5.get("count")).intValue(), 1);
    }
}
